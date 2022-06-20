using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Clinica_DSII.Entidades;
using System.Data;
using Clinica_DSII.ViewClass;

namespace Clinica_DSII.Dao
{
    public class DaoReserva
    {
        private SqlConnection cone = new SqlConnection("Server=LAPTOP-OB4D3M28; Database=clinicaDSII; Integrated Security=true");

        public List<ViewConsultasDisponibles> GetViewConsultasDisponibles(int idesp, int idhor,string fcitab) {
            List<ViewConsultasDisponibles> list = new List<ViewConsultasDisponibles>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_BUSCAR_CONSULTAS_FECHA_SUPERIOR_HOY_1", cone);
                cmd.Parameters.AddWithValue("@idesp", idesp);
                cmd.Parameters.AddWithValue("@idhor", idhor);
                cmd.Parameters.AddWithValue("@fechab", fcitab);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewConsultasDisponibles vre = new ViewConsultasDisponibles();
                    vre.idconsulta = int.Parse(reader["Idconsulta"].ToString());
                    vre.medico = reader["Medico"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
                    vre.precio = double.Parse(reader["Precio"].ToString());
                    vre.horainicio = TimeSpan.Parse(reader["horainicio"].ToString());
                    vre.horafinal = TimeSpan.Parse(reader["horafinal"].ToString());
                    vre.mensaje = reader["Mensaje"].ToString();
                    list.Add(vre);
                }
            }
            catch (Exception e)
            {

            }
            cone.Close();

            return list;
        }
    
        public int save(Reserva res) {
            SqlCommand cmd = new SqlCommand("PROC_CREAR_RESERVA_EFECTIVO", cone);
            cmd.Parameters.AddWithValue("@idpac", res.idpaciente);
            cmd.Parameters.AddWithValue("@idconsulta", res.idconsulta);
            cmd.Parameters.AddWithValue("@fechacita", res.fechacita);
            cmd.Parameters.AddWithValue("@montoentre", res.montoentregado);
            cmd.Parameters.AddWithValue("@idtransaccion", res.idtransicion);
            cmd.CommandType = CommandType.StoredProcedure;


            cone.Open(); // Abrir la conexion al servidor
            int rpt = cmd.ExecuteNonQuery(); // Enviar la orden al servidor

            cone.Close(); // Cerrar la conexion al servidor
            cmd.Dispose(); // Liberar recursos del comando            

            return rpt;
        }
        
        public List<ViewTransaccion> getfilterDateReservas(string ffinicio, string ffinal)
        {
            List<ViewTransaccion> list = new List<ViewTransaccion>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_RESERVA_FILTRO_FECHA", cone);
                cmd.Parameters.AddWithValue("@finicio", ffinicio);
                cmd.Parameters.AddWithValue("@ffinal", ffinal);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewTransaccion vre = new ViewTransaccion();
                    vre.transaccion = reader["Transaccion"].ToString();
                    vre.medico = reader["Medico"].ToString();
                    vre.paciente = reader["Paciente"].ToString();
                    vre.dni = reader["Dni"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
                    vre.precio = reader["Precio"].ToString();
                    vre.estado = reader["Estado"].ToString();
                    vre.freserva = DateTime.Parse(reader["Freserva"].ToString());
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    vre.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                    vre.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
                    list.Add(vre);
                }
            }
            catch (Exception e)
            {

            }
            cone.Close();

            return list;
        }

        public List<ViewTransaccion> getTransaccionReservas()
        {
            List<ViewTransaccion> list = new List<ViewTransaccion>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_TRASACCION_RESERVAS", cone);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewTransaccion vre = new ViewTransaccion();
                    vre.transaccion = reader["Transaccion"].ToString();
                    vre.medico = reader["Medico"].ToString();
                    vre.paciente = reader["Paciente"].ToString();
                    vre.dni = reader["Dni"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
                    vre.precio = reader["Precio"].ToString();
                    vre.estado = reader["Estado"].ToString();
                    vre.freserva = DateTime.Parse(reader["Freserva"].ToString());
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    vre.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                    vre.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
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