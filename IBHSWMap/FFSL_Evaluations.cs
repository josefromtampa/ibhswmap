//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace IBHSWMap
{
    using System;
    using System.Collections.Generic;
    
    public partial class FFSL_Evaluations
    {
        public int ID { get; set; }
        public int JobId { get; set; }
        public Nullable<int> StateId { get; set; }
        public string Zip { get; set; }
        public string City { get; set; }
        public string Address { get; set; }
        public string HomeType { get; set; }
        public Nullable<int> YearBuilt { get; set; }
        public string StructureSystem { get; set; }
        public Nullable<int> SquareFootage { get; set; }
        public string LotSize { get; set; }
        public Nullable<int> Stories { get; set; }
        public Nullable<int> Decks { get; set; }
        public Nullable<int> AttachedStructures { get; set; }
        public string Builder { get; set; }
        public string Inspector { get; set; }
        public string ProjectManager { get; set; }
        public Nullable<bool> Suspended { get; set; }
        public Nullable<bool> Designated { get; set; }
        public Nullable<bool> InProgress { get; set; }
        public Nullable<System.DateTime> DesignatedDate { get; set; }
        public Nullable<System.DateTime> InpectedDate { get; set; }
        public string lat { get; set; }
        public string @long { get; set; }
    }
}
