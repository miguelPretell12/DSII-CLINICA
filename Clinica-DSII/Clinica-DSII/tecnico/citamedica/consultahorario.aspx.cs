using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Clinica_DSII.Entidades;
using Clinica_DSII.Dao;
using System.Data;
using System.Web.Services;
using System.Data.SqlClient;
using Clinica_DSII.ViewClass;


namespace Clinica_DSII.tecnico.citamedica
{
    public partial class consultahorario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static List<Horario> getHorarios()
        {
            DaoHorario dao = new DaoHorario();
            return dao.listar();
        }

        [WebMethod]
        public static List<ViewConsultasDisponibles> obtenerConsultaDisponible(string idhorario) {
            DaoReservaConsulta dao = new DaoReservaConsulta();
            int idhor = int.Parse(idhorario);
            return dao.listarConsultasHorarios(idhor);
        }

        [WebMethod]
        public static Paciente searchPaciente(string dni)
        {
            DaoReservaConsulta dao = new DaoReservaConsulta();
            return dao.searchPaciente(dni);
        }

        [WebMethod]
        public static int save(string idpaciente, string idconsulta, string fechacita, string montoentregado, string idtransicion)
        {
            DaoReservaConsulta dao = new DaoReservaConsulta();
            // 
            Reserva res = new Reserva();
            res.idconsulta = int.Parse(idconsulta);
            res.idpaciente = int.Parse(idpaciente);
            res.fechacita = DateTime.Parse(fechacita);
            res.montoentregado = double.Parse(montoentregado);
            res.idtransicion = idtransicion;
            return dao.save(res);
        }

        [WebMethod]
        public static List<ViewReservas> listaReservasTransicion()
        {
            DaoReservaConsulta dao = new DaoReservaConsulta();
            return dao.listarReservas();
        }

        [WebMethod]
        public static List<ViewReservas> listarbuscartransicion(string idtransicion)
        {
            DaoReservaConsulta dao = new DaoReservaConsulta();
            return dao.buscarTransicion(idtransicion);
        }

    }
}