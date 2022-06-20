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

namespace Clinica_DSII.medico.citamedica
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
       public static ViewReservaMedico buscar(string trandni)
        {
            DaoMedicoFicha dao = new DaoMedicoFicha();
            string idmed = HttpContext.Current.Session["idusuario"] as string;
            return dao.buscarReservaDniTransaccion(trandni, idmed);
        }

        [WebMethod]
        public static int save(string idreserva, string alergia, string peso, string estatura, string observacion, string receta )
        {
            DaoMedicoFicha dao = new DaoMedicoFicha();
            return dao.save(idreserva, alergia, peso, estatura, observacion, receta);
        }

    
    }
}