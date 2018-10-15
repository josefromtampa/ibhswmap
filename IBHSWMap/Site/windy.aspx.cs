using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace IBHSWMap.Site
{
    public partial class windy : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //check token:
            string usr = GetLoggedInUser();
            ServerException.Value = usr;

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
                }
                catch (Exception e)
                {
                    ret = e.ToString();
                }
                // ret = "Howdie";
            }
            return ret;
        }
    }
}