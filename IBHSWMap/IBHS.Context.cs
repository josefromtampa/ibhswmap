﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class IBHSEntities : DbContext
    {
        public IBHSEntities()
            : base("name=IBHSEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Evaluation> Evaluations { get; set; }
        public virtual DbSet<State> States { get; set; }
        public virtual DbSet<DesignationType> DesignationTypes { get; set; }
        public virtual DbSet<HomeProgramType> HomeProgramTypes { get; set; }
        public virtual DbSet<FFSL_Evaluations> FFSL_Evaluations { get; set; }
    }
}