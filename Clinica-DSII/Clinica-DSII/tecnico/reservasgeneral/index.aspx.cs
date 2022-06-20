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

namespace Clinica_DSII.tecnico.reservasgeneral
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static Paciente searchPaciente(string dni) {
            DaoReservaConsulta dao = new DaoReservaConsulta();
            return dao.searchPaciente(dni);
        }

        [WebMethod]
        public static List<Horario> getHorarios()
        {
            DaoHorario dao = new DaoHorario();
            return dao.listar();
        }

        [WebMethod]
        public static List<Especialidad> getEspecialidades()
        {
            DaoMedicoEspecialidad dao = new DaoMedicoEspecialidad();
            return dao.especialidades();
        }

        [WebMethod]
        public static List<ViewConsultasDisponibles> searchConsultaFiltro(string horarios, string especialidads, string fcitab) {
            DaoReserva dao = new DaoReserva();
            int idhor = int.Parse(horarios);
            int esp = int.Parse(especialidads);
            return dao.GetViewConsultasDisponibles(esp, idhor, fcitab);
        }

        [WebMethod]
        public static int saveReserva(string montoentregado, string idconsulta, string fechacita, string idpaciente, string transaccion)
        {
            DaoReserva dao = new DaoReserva();
            Reserva res = new Reserva();
            res.montoentregado = double.Parse(montoentregado);
            res.idconsulta = int.Parse(idconsulta);
            res.fechacita = DateTime.Parse(fechacita);
            res.idtransicion = transaccion;
            res.idpaciente = int.Parse(idpaciente);
            return dao.save(res);
        }
    }
}