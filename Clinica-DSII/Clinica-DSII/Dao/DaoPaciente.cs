using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using Clinica_DSII.Entidades;

namespace Clinica_DSII.Dao
{
    public class DaoPaciente
    {
        private SqlConnection cone = new SqlConnection("Server=LAPTOP-OB4D3M28; Database=clinicaDSII; Integrated Security=true");
        DataSet ds = new DataSet();

        public DataSet listar()
        {
            SqlDataAdapter da = new SqlDataAdapter("select " +
                " nombre as Nombre, apellido as Apellido, dni as DNI, correo as Correo_Electronico, fechanacimiento as Fecha_nacimiento " +
                " from pacientes", cone);
            da.Fill(ds);
            return ds;
        }

        public List<Paciente> listarp ()
        {
            List<Paciente> list = new List<Paciente>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_PACIENTE", cone);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    Paciente pac = new Paciente();
                    pac.idpacientes = int.Parse(reader["Idpacientes"].ToString());
                    pac.nombre = reader["Nombre"].ToString();
                    pac.apellido = reader["Apellido"].ToString();
                    pac.dni = reader["Dni"].ToString();
                    pac.correo = reader["Correo"].ToString();
                    pac.estadocivil = reader["Estadocivil"].ToString();
                    pac.fechanacimiento = DateTime.Parse(reader["Fechanacimiento"].ToString());
                    pac.contrasenia = reader["contrasenia"].ToString();
                    list.Add(pac);
                }
            }
            catch (Exception e)
            {

            }
            cone.Close();

            return list;
        }

        public int save(Paciente pac) {
            SqlCommand cmd = new SqlCommand("PROC_INSERTAR_PACIENTE", cone);
            cmd.Parameters.AddWithValue("@nombre", pac.nombre);
            cmd.Parameters.AddWithValue("@apellido", pac.apellido);
            cmd.Parameters.AddWithValue("@dni", pac.dni);
            cmd.Parameters.AddWithValue("@correo", pac.correo);
            cmd.Parameters.AddWithValue("@fechanac", pac.fechanacimiento);
            cmd.Parameters.AddWithValue("@estadocivil", pac.estadocivil);
            cmd.Parameters.AddWithValue("@contrasenia", pac.contrasenia);
            cmd.CommandType = CommandType.StoredProcedure;

            // sql parameter
            SqlParameter retorno = new SqlParameter();
            retorno.Direction = ParameterDirection.ReturnValue;

            cmd.Parameters.Add(retorno);
            cone.Open(); // Abrir la conexion al servidor
            cmd.ExecuteNonQuery(); // Enviar la orden al servidor

            int rpt = (int)retorno.Value;
            cone.Close(); // Cerrar la conexion al servidor
            cmd.Dispose(); // Liberar recursos del comando  

            return rpt;
        }

        public int update(Paciente pac) {
            int rpt;
            SqlCommand cmd = new SqlCommand("PROC_UPDATE_PACIENTE", cone);
            cmd.Parameters.AddWithValue("@nombre", pac.nombre);
            cmd.Parameters.AddWithValue("@apellido", pac.apellido);
            cmd.Parameters.AddWithValue("@dni", pac.dni);
            cmd.Parameters.AddWithValue("@correo", pac.correo);
            cmd.Parameters.AddWithValue("@fechanac", pac.fechanacimiento);
            cmd.Parameters.AddWithValue("@estadocivil", pac.estadocivil);
            cmd.Parameters.AddWithValue("@contrasenia", pac.contrasenia);
            cmd.Parameters.AddWithValue("@idpaciente", pac.idpacientes);
            cmd.CommandType = CommandType.StoredProcedure;
            cone.Open(); // Abrir la conexion al servidor

            rpt=cmd.ExecuteNonQuery(); // Enviar la orden al servidor
            cone.Close();
            cmd.Dispose();

            return rpt;
        }

        public int delete(int idpaciente)
        {
            SqlCommand cmd = new SqlCommand("PROC_ELIMINAR_PACIENTE", cone);
            cmd.Parameters.AddWithValue("@idpaciente", idpaciente);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter retorno = new SqlParameter();
            retorno.Direction = ParameterDirection.ReturnValue;

            cmd.Parameters.Add(retorno);
            cone.Open(); // Abrir la conexion al servidor
            cmd.ExecuteNonQuery(); // Enviar la orden al servidor

            int rpt = (int)retorno.Value;
            cone.Close(); // Cerrar la conexion al servidor
            cmd.Dispose(); // Liberar recursos del comando  
            return rpt;
        }

        public Paciente getPaciente(int idpaciente)
        {
            Paciente pac = new Paciente();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_OBTENER_PACIENTE", cone);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@idpaciente", idpaciente);
                reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    pac.idpacientes = int.Parse(reader["Idpacientes"].ToString());
                    pac.nombre = reader["Nombre"].ToString();
                    pac.apellido = reader["Apellido"].ToString();
                    pac.dni = reader["Dni"].ToString();
                    pac.correo = reader["Correo"].ToString();
                    pac.fechanacimiento = DateTime.Parse(reader["fechanacimiento"].ToString());
                    pac.estadocivil = reader["Estadocivil"].ToString();
                    pac.contrasenia = reader["Contrasenia"].ToString();
                }
            }
            catch (Exception e)
            {

            }
            cone.Close();
            return pac;
        }

        public Boolean insertar(Paciente pac) {
            try
            {
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "Insert into pacientes values (@nom, @ape, @dni, @correo, @fechan)";
                cmd.Parameters.AddWithValue("@nom", pac.nombre);
                cmd.Parameters.AddWithValue("@ape", pac.apellido);
                cmd.Parameters.AddWithValue("@dni", pac.dni);
                cmd.Parameters.AddWithValue("@correo", pac.correo);
                cmd.Parameters.AddWithValue("@fechan", pac.fechanacimiento);
                cmd.CommandType = CommandType.Text;
                cmd.Connection = cone;
                cone.Open(); // Abrir la conexion al servidor
                cmd.ExecuteNonQuery(); // Enviar la orden al servidor
                cone.Close(); // Cerrar la conexion al servidor
                cmd.Dispose(); // Liberar recursos del comando

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}