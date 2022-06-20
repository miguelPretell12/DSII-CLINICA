using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Clinica_DSII.ViewClass;
using Clinica_DSII.Entidades;
using System.Data.SqlClient;

namespace Clinica_DSII.Dao
{
    public class DaoLogin
    {
        private SqlConnection cone = new SqlConnection("Server=LAPTOP-OB4D3M28; Database=clinicaDSII; Integrated Security=true");

        public ViewLogin login(Usuario usu)
        {
            SqlCommand cmd = new SqlCommand("PROC_LOGIN", cone);
            cmd.Parameters.AddWithValue("@correo", usu.correo);
            cmd.Parameters.AddWithValue("@contrasenia", usu.contrasenia);
            cmd.CommandType = CommandType.StoredProcedure;
            ViewLogin lg = new ViewLogin();
            cone.Open();
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                lg.idusuario = reader["Idusuario"].ToString();
                lg.cargo = reader["Cargo"].ToString();
                lg.usuarios = reader["Usuarios"].ToString();
            }

            cone.Close();

            return lg;
        }
    }
}