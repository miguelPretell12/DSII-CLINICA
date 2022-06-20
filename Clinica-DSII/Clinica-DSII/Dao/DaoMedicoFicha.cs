using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Clinica_DSII.ViewClass;
using Clinica_DSII.Entidades;
using System.Data.SqlClient;

namespace Clinica_DSII.Dao
{
    public class DaoMedicoFicha
    {
        private SqlConnection cone = new SqlConnection("Server=LAPTOP-OB4D3M28; Database=clinicaDSII; Integrated Security=true");

        public int save(string idres, string alergia, string peso, string estatura, string observacion, string receta) {
            SqlCommand cmd = new SqlCommand("PROC_MEDICO_SAVE_FICHA_HISTORIAL", cone);
            cmd.Parameters.AddWithValue("@idres", idres);
            cmd.Parameters.AddWithValue("@alergia", alergia);
            cmd.Parameters.AddWithValue("@peso", peso);
            cmd.Parameters.AddWithValue("@estatura", estatura);
            cmd.Parameters.AddWithValue("@observacion", observacion);
            cmd.Parameters.AddWithValue("@receta", receta);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cone;
            cone.Open(); // Abrir la conexion al servidor
            int rpta = cmd.ExecuteNonQuery(); // Enviar la orden al servidor
            cone.Close(); // Cerrar la conexion al servidor
            cmd.Dispose(); // Liberar recursos del comando
            return rpta;
        }

        public ViewReservaMedico buscarReservaDniTransaccion(string trandni, string idmed)
        {
            ViewReservaMedico pac = new ViewReservaMedico();

            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            cmd = new SqlCommand("PROC_RESERVAR_TRANSACCION_DNI_MEDICO", cone);
            cmd.Parameters.AddWithValue("@trandni", trandni);
            cmd.Parameters.AddWithValue("@idmed", idmed);
            cmd.CommandType = CommandType.StoredProcedure;
            reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                pac.idreserva = int.Parse(reader["Idreserva"].ToString());
                pac.medico = reader["Medico"].ToString();
                pac.paciente = reader["Paciente"].ToString();
                pac.dni = reader["Dni"].ToString();
                pac.estado = reader["Estado"].ToString();
                pac.especialidad = reader["Especialidad"].ToString();
                pac.transaccion = reader["transaccion"].ToString();
            }
            cone.Close();

            return pac;
        }

        public List<ViewCitaMedico> getfilterCitasMedico(string fcita, string idmed) {
            List<ViewCitaMedico> list = new List<ViewCitaMedico>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_RESERVAS_MED_FILTER", cone);
                cmd.Parameters.AddWithValue("@fcita", fcita);
                cmd.Parameters.AddWithValue("@idmed", idmed);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewCitaMedico vre = new ViewCitaMedico();
                    vre.transaccion = reader["Transaccion"].ToString();
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    vre.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                    vre.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
                    vre.paciente = reader["Paciente"].ToString();
                    vre.dni = reader["Dni"].ToString();
                    vre.estado = reader["Estado"].ToString();
                    list.Add(vre);
                }
            }
            catch (Exception e)
            {

            }
            cone.Close();

            return list;
        }

        public List<ViewCitaMedico> getCitasMedico(string idmed)
        {
            List<ViewCitaMedico> list = new List<ViewCitaMedico>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_RESERVAS_MED", cone);
                cmd.Parameters.AddWithValue("@idmed", idmed);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewCitaMedico vre = new ViewCitaMedico();
                    vre.transaccion = reader["Transaccion"].ToString();
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    vre.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                    vre.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
                    vre.paciente = reader["Paciente"].ToString();
                    vre.dni = reader["Dni"].ToString();
                    vre.estado = reader["Estado"].ToString();
                    list.Add(vre);
                }
            }
            catch (Exception e)
            {
                
            }
            cone.Close();

            return list;
        }
    }
}