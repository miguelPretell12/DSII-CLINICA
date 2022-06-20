using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Clinica_DSII.Dao;
using Clinica_DSII.Entidades;
using Clinica_DSII.ViewClass;
using System.Web.Services;

namespace Clinica_DSII.tecnico.pacientes
{
    public partial class indexx : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static List<Paciente> getPacientes()
        {
            DaoPaciente dao = new DaoPaciente();
            return dao.listarp();
        }

        [WebMethod]
        public static int save(string nombre, string apellido, string dni, string correo, string fechanacimiento, string estadocivil, string contrasenia)
        {
            DaoPaciente dao = new DaoPaciente();
            Paciente pac = new Paciente();
            pac.nombre = nombre;
            pac.apellido = apellido;
            pac.dni = dni;
            pac.correo = correo;
            pac.fechanacimiento = DateTime.Parse(fechanacimiento);
            pac.estadocivil= estadocivil;
            pac.contrasenia = contrasenia;
            return dao.save(pac);
        }

        [WebMethod]
        public static int update(string nombre, string apellido, string dni, string correo, string fechanacimiento, string estadocivil, string contrasenia, string idpaciente) {
            DaoPaciente dao = new DaoPaciente();
            Paciente pac = new Paciente();
            pac.nombre = nombre;
            pac.apellido = apellido;
            pac.dni = dni;
            pac.correo = correo;
            pac.fechanacimiento = DateTime.Parse(fechanacimiento);
            pac.estadocivil = estadocivil;
            pac.contrasenia = contrasenia;
            pac.idpacientes = int.Parse(idpaciente);

            return dao.update(pac);
        }

        [WebMethod]
        public static Paciente getPaciente(string idpaciente)
        {
            DaoPaciente dao = new DaoPaciente();
            int idpac = int.Parse(idpaciente);
            return dao.getPaciente(idpac);
        }

        [WebMethod]
        public static int delete(string idpaciente)
        {
            DaoPaciente dao = new DaoPaciente();
            int idpac = int.Parse(idpaciente);
            return dao.delete(idpac);
        }

        [WebMethod]
        public static ViewPacienteSaldo searchPaciente(string dni)
        {
            DaoReservaConsulta dao = new DaoReservaConsulta();
            return dao.searchPacienteSaldo(dni);
        }

        [WebMethod]
        public static int recargaPaciente(string idpac, string saldo)
        {
            DaoReservaConsulta dao = new DaoReservaConsulta();
            int idpaciente = int.Parse(idpac);
            double sald = double.Parse(saldo);
            return dao.recargaPac(idpaciente, sald);
        }
    }
}