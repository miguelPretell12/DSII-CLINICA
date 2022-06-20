using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Clinica_DSII.Entidades;
using Clinica_DSII.ViewClass;
using Clinica_DSII.Dao;
using System.Data;
using System.Web.Services;
using System.Data.SqlClient;


namespace Clinica_DSII.medico.historial
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static List<ViewCitaMedico> getfiltercitamedico(string fcita)
        {
            DaoMedicoFicha dao = new DaoMedicoFicha();
            return dao.getfilterCitasMedico(fcita, "3");
        }

        [WebMethod]
        public static List<ViewCitaMedico> getcitamedico()
        {
            DaoMedicoFicha dao = new DaoMedicoFicha();
            return dao.getCitasMedico("3");
        }
    }
}