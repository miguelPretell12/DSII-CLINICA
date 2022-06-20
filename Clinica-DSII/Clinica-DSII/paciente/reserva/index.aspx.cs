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

namespace Clinica_DSII.paciente.reserva
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        [WebMethod]
        public static List<ViewPacienteReserva> GetViewPacienteReservasId()
        {
            DaoPacienteReserva dao = new DaoPacienteReserva();
            ViewLogin v = new ViewLogin();
            int idpac = int.Parse(v.getIdUsuario());
            return dao.GetPacienteReservasFind(idpac);
        }

        [WebMethod]
        public static List<ViewConsultasDisponibles> obtenerConsulta(string idesp, string idhor, string fechacita)
        {
            DaoPacienteReserva dao = new DaoPacienteReserva();
            int ides = int.Parse(idesp);
            int idhr = int.Parse(idhor);
            DateTime fcita = DateTime.Parse(fechacita);
            return dao.GetViewConsultas(ides, idhr, fcita);
        }

        [WebMethod]
        public static int save(string transaccion, string fcita, string idcons)
        {
            DaoPacienteReserva dao = new DaoPacienteReserva();
            Reserva res = new Reserva();
            res.idtransicion = transaccion;
            res.fechacita = DateTime.Parse(fcita);
            res.idconsulta = int.Parse(idcons);
            res.idpaciente = int.Parse(HttpContext.Current.Session["idusuario"] as string);

            return dao.guardarReserva(res);
        }

        [WebMethod]
        public static double mostrarSaldo()
        {
            DaoPacienteReserva v = new DaoPacienteReserva();
            string idpac = HttpContext.Current.Session["idusuario"] as string;
            return v.getSaldoPaciente(idpac);
        }

        [WebMethod]
        public static int saveVirtual(string transaccion, string fcita, string idcons)
        {
            DaoPacienteReserva dao = new DaoPacienteReserva();
            Reserva res = new Reserva();
            res.idtransicion = transaccion;
            res.fechacita = DateTime.Parse(fcita);
            res.idconsulta = int.Parse(idcons);
            res.idpaciente = int.Parse(HttpContext.Current.Session["idusuario"] as string);
            return dao.saveReservaVirtual(res);
        }

    }
}