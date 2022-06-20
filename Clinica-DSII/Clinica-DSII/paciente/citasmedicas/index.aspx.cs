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

namespace Clinica_DSII.paciente.citasmedicas
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static List<ViewCitaPaciente> getHistorialFilter(string transaccion) {
            DaoPacienteReserva dao = new DaoPacienteReserva();
            string idpac = HttpContext.Current.Session["idusuario"] as string;
            return dao.getReservaPacienteTransaccion(idpac, transaccion);
        }

        [WebMethod]
        public static List<ViewCitaPaciente> getHistorial()
        {
            DaoPacienteReserva dao = new DaoPacienteReserva();
            string idpac = HttpContext.Current.Session["idusuario"] as string;
            return dao.getReservaPaciente(idpac);
        }

        [WebMethod]
        public static ViewFMPaciente GetFMPacientes(string transaccion) {
            DaoPacienteReserva dao = new DaoPacienteReserva();
            string idpac = HttpContext.Current.Session["idusuario"] as string;
            return dao.GetFMPacientes(idpac, transaccion);
        }

    }
}