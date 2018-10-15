using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;

namespace IBHSWMap
{
    [ServiceContract(Namespace = "")]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class evaluations
    {
        // To use HTTP GET, add [WebGet] attribute. (Default ResponseFormat is WebMessageFormat.Json)
        // To create an operation that returns XML,
        //     add [WebGet(ResponseFormat=WebMessageFormat.Xml)],
        //     and include the following line in the operation body:
        //         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml";
       
        [OperationContract]
        [WebInvoke(Method = "GET", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        public LatLongAddressResponse GetAddresses()
        {

            LatLongAddressResponse ret = new LatLongAddressResponse();

            //check for auth token:
            string loggedInUser = GetLoggedInUser();
            bool ShowDetails = false;
            if (!string.IsNullOrEmpty(loggedInUser))
            {
                ShowDetails = true;

            }

            using (IBHSEntities db = new IBHSEntities())
            {
                var q = (from evals in db.Evaluations
                         join st in db.States on evals.PropertyStateId equals st.StateId
                         join ds in db.DesignationTypes on evals.DesignationTypeId equals ds.DesignationTypeId
                         where evals.StatusId == 12
                         select new LatLongAddress
                         {
                             FFSL = false,
                             Lat = evals.Latitude,
                             Lng = evals.Longitude,
                             FullAddress = ShowDetails ?  evals.PropertyAddress1 + ", " + evals.PropertyCity + ", " + st.StateCode + " " + evals.PropertyPostalCode : "",
                             Address = ShowDetails ?  evals.PropertyAddress1 + (string.IsNullOrEmpty(evals.PropertyAddress2) ? "" : " " + evals.PropertyAddress2) : "",
                             City = ShowDetails ? evals.PropertyCity : "",
                             State =  ShowDetails ? st.StateCode : "",
                             //ZipStr = "",
                             Zip = ShowDetails ?  evals.PropertyPostalCode : 0,
                             FID = ShowDetails ?  evals.FortifiedId : "***********" +  evals.FortifiedId.Substring( evals.FortifiedId.Length - 4),
                             ProgramType = evals.HomeProgramType.Description,
                             DesignationType = ds.Description
                         });

                var qFFSL = (
                            from evalFFS in db.FFSL_Evaluations
                            join st in db.States on evalFFS.StateId equals st.StateId
                            //where st.StateId == 9 && evalFFS.City.Contains("alys")
                            select new LatLongAddress
                            {
                                FFSL = true,
                                Lat = evalFFS.lat,
                                Lng = evalFFS.@long,
                                FullAddress = ShowDetails ? evalFFS.Address + ", " + evalFFS.City + ", " + st.StateCode + " " + evalFFS.Zip : "",
                                Address = ShowDetails ?  evalFFS.Address : "",
                                City = ShowDetails ?  evalFFS.City : "",
                                State =ShowDetails ?  st.StateCode : "",
                                //Zip = 0,
                                ZipStr = ShowDetails ? evalFFS.Zip.Trim() : "",
                                FID = ShowDetails ?  "FFSL_" + evalFFS.JobId : "FFSL_*******"  ,
                                ProgramType = "Fortified For Safer Living",
                                DesignationType = evalFFS.Designated.HasValue && evalFFS.Designated.Value ? "Designated" : "Not Designated"

                            }


                         );



                //ret.AddressList = q.ToArray<LatLongAddress>();

                //LatLongAddress[] qFFSL_Arr = qFFSL.ToArray<LatLongAddress>();


                //ret.AddressList.Union<LatLongAddress>(qFFSL_Arr);



                List<LatLongAddress> qFFSL_List = qFFSL.Take(10).ToList<LatLongAddress>();
                List<LatLongAddress> q_List = q.Take(10).ToList<LatLongAddress>();

                qFFSL_List.AddRange(q_List);

                ret.AddressList = qFFSL_List.ToArray<LatLongAddress>();
                ret.UserId = loggedInUser;
               
            }

            return ret;

        }

        private string GetLoggedInUser()
        {
            string ret = null;
            string cookieName = System.Web.Security.FormsAuthentication.FormsCookieName;
            //string cookieName = "FormsAuthentication";
            System.Web.HttpCookie authCookie = System.Web.HttpContext.Current.Request.Cookies[cookieName];
            if (authCookie != null)
            {
                try
                {
                    System.Web.Security.FormsAuthenticationTicket ticket = System.Web.Security.FormsAuthentication.Decrypt(authCookie.Value);
                    //ret = ticket.Name;
                } catch (Exception e)
                {
                    ret = e.ToString();
                }
               // ret = "Howdie";
            }
            return ret;
        }

        public static int parseIntLINQ(string str)
        {
            int res;
            res = Int32.TryParse(str, out res) ? res : 0;
            return res;
        }
        // Add more operations here and mark them with [OperationContract]
    }

    public class LatLongAddressResponse
    {
        public LatLongAddress[] AddressList {get;set;}
        public string UserId { get;  set; }
    }

    public class LatLongAddress
    {
        public string Lat { get; set; }
        public string Lng { get; set; }
        public string Address { get; set; }
        public string FID { get; set; }
        public string ProgramType { get;   set; }
        public string DesignationType { get;   set; }
        public string FullAddress { get;   set; }
        public string City { get;   set; }
        public string State { get;   set; }
        private int zipint;
        public int Zip {
            get {
                return zipint;
            }
            set {
                zipint = value;
                _zipStr = zipint.ToString();
            }
        }
        public bool FFSL { get;   set; }
        private string _zipStr;
        public string ZipStr {
            get
            {
                return _zipStr;

            }
            set
            {
                _zipStr = value;
                int res;
                bool tryIt = int.TryParse(_zipStr, out res);
                if (tryIt)
                {
                    zipint = res; 
                }
            }
        }
    }
}
