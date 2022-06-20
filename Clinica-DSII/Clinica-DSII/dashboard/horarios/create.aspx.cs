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

namespace Clinica_DSII.dashboard.horarios
{
    public partial class creates : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static List<Horario> listar()
        {
            DaoHorario dao = new DaoHorario();
            return dao.listar();
        }

        [WebMethod]
        public static Horario obtenerHorario(string id)
        {
            DaoHorario dao = new DaoHorario();
            int idhor = int.Parse(id); 
            return dao.getHorario(idhor);
        }

        [WebMethod]
        public static int filtroExist(string horainicio, string horafinal) {
            DaoHorario dao = new DaoHorario();
            return dao.filtro(horainicio, horafinal);
        }

        [WebMethod]
        public static int guardar(string horainicio, string horafinal)
        {
            DaoHorario dao = new DaoHorario();
            Horario hor = new Horario();
            hor.horainicio = TimeSpan.Parse(horainicio);
            hor.horafinal = TimeSpan.Parse(horafinal);
            return dao.guardar(hor);
        }

        [WebMethod]
        public static int actualizar(string horainicio, string horafinal, string idhorario) {
            DaoHorario dao = new DaoHorario();
            Horario hor = new Horario();
            hor.horainicio = TimeSpan.Parse(horainicio);
            hor.horafinal = TimeSpan.Parse(horafinal);
            hor.idhorario = int.Parse(idhorario);
            return dao.actualizar(hor);
        }

        [WebMethod]
        public static int eliminar(string idhorario)
        {
            DaoHorario dao = new DaoHorario();
            Horario hor = new Horario();
            hor.idhorario = int.Parse(idhorario);
            return dao.eliminar(hor);
        }

        [WebMethod]
        public static ViewEspecialidadMedico obtenerMedico(string dni)
        {
            DaoMedicoEspecialidad dao = new DaoMedicoEspecialidad();
            return dao.getMedicoEspecialidad(dni);
        }


        [WebMethod]
        public static List<Especialidad> listarEspecialidad()
        {
            DaoMedicoEspecialidad dao = new DaoMedicoEspecialidad();

            return dao.especialidades();
        }

        [WebMethod]
        public static int save(string idesp, string idusuario)
        {
            DaoMedicoEspecialidad dao = new DaoMedicoEspecialidad();
            return dao.save(idesp, idusuario);
        }

        [WebMethod]
        public static int update(string idesp, string idusuario, string idespmed)
        {
            DaoMedicoEspecialidad dao = new DaoMedicoEspecialidad();
            return dao.update(idesp, idusuario, idespmed);
        }
        [WebMethod]
        public static List<ViewEspecialidadMedico> searchEspMed(string dni)
        {
            DaoMedicoEspecialidad dao = new DaoMedicoEspecialidad();
            return dao.searchEspMed(dni);
        }

        [WebMethod]
        public static List<ViewEspecialidadMedico> ListEspMed()
        {
            DaoMedicoEspecialidad dao = new DaoMedicoEspecialidad();
            return dao.ListEspMed();
        }

        [WebMethod]
        public static int deleteEspMed(string idespmed)
        {
            DaoMedicoEspecialidad dao = new DaoMedicoEspecialidad();
            return dao.delete(idespmed);
        }
    }
}