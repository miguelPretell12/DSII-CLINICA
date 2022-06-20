using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Clinica_DSII.Dao;
using Clinica_DSII.Entidades;
using Clinica_DSII.ViewClass;
using System.Data.SqlClient;
using System.Web.Services;

namespace Clinica_DSII
{
    public partial class login : System.Web.UI.Page
    {
        Usuario usu = new Usuario();
        DaoUsuario dao = new DaoUsuario();

        DataTable dt = new DataTable();
        // Conexion de Base de datos - SQL Server
        private SqlConnection cone = new SqlConnection("Server=LAPTOP-OB4D3M28;Database=clinicaDSII;Integrated Security = true");
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                string cargo = Session["sessioncargo"] as string;
                if (cargo != null)
                {
                    if (cargo == "administrador")
                    {
                        Response.Redirect("/dashboard/admin");
                    }
                    else if (cargo == "tecnico")
                    {
                        Response.Redirect("/tecnico/index");
                    }
                    else if (cargo == "doctor")
                    {
                        Response.Redirect("/medico/index");
                    }
                    else if(cargo == "paciente")
                    {
                        Response.Redirect("/paciente/index");
                    }
                }
            }
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
           
        }

        [WebMethod]
        public static ViewLogin Login(string correo, string password) {
            DaoLogin dao = new DaoLogin();
            Usuario usu = new Usuario();
            usu.correo = correo;
            usu.contrasenia = password;
            // Agregar datos a la session
            ViewLogin vl = dao.login(usu);
            HttpContext.Current.Session["sesionusuario"] = vl.usuarios;
            HttpContext.Current.Session["sessioncargo"] = vl.cargo;
            HttpContext.Current.Session["idusuario"] = vl.idusuario;
            return vl;
        }
    }
}