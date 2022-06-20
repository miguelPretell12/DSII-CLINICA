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
    public class DaoPacienteReserva
    {
        private SqlConnection cone = new SqlConnection("Server=LAPTOP-OB4D3M28; Database=clinicaDSII; Integrated Security=true");

        public List<ViewPacienteReserva> GetPacienteReservasFind(int id)
        {
            List<ViewPacienteReserva> list = new List<ViewPacienteReserva>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_RESERVAS_PAC", cone);
                cmd.Parameters.AddWithValue("@idpac", id);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewPacienteReserva vre = new ViewPacienteReserva();
                    vre.transaccion = reader["Transaccion"].ToString();
                    vre.medico = reader["Medico"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    vre.hinicio = TimeSpan.Parse(reader["Hinicio"].ToString());
                    vre.hfinal = TimeSpan.Parse(reader["Hfinal"].ToString());
                    vre.precio = double.Parse(reader["Precio"].ToString());
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

        public List<ViewConsultasDisponibles> GetViewConsultas(int idesp, int idhor, DateTime fcita)
        {
            List<ViewConsultasDisponibles> list = new List<ViewConsultasDisponibles>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_BUSCAR_CONSULTA_HOR_ESP", cone);
                cmd.Parameters.AddWithValue("@especialidad", idesp);
                cmd.Parameters.AddWithValue("@horario", idhor);
                cmd.Parameters.AddWithValue("@fechacita", fcita);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewConsultasDisponibles vre = new ViewConsultasDisponibles();
                    vre.idconsulta = int.Parse(reader["Idconsulta"].ToString());
                    vre.medico = reader["Medico"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
                    vre.precio = double.Parse(reader["Precio"].ToString());
                    vre.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                    vre.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
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
    
        public int guardarReserva(Reserva res)
        {
            SqlCommand cmd = new SqlCommand("PROC_RESERVAR_PACIENTE_SAVE", cone);
            cmd.Parameters.AddWithValue("@idpac", res.idpaciente );
            cmd.Parameters.AddWithValue("@idcons", res.idconsulta );
            cmd.Parameters.AddWithValue("@fcita", res.fechacita);
            cmd.Parameters.AddWithValue("@idtransaccion", res.idtransicion);
            cmd.CommandType = CommandType.StoredProcedure;
            cone.Open(); // Abrir la conexion al servidor
            int rpta = cmd.ExecuteNonQuery(); // Enviar la orden al servidor
            cone.Close(); // Cerrar la conexion al servidor
            cmd.Dispose(); // Liberar recursos del comando
            return rpta;
        }

        public List<ViewCitaPaciente> getReservaPacienteTransaccion(string idpac,string transaccion)
        {
            List<ViewCitaPaciente> list = new List<ViewCitaPaciente>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_RESERVA_PACIENTE_TRANS_FILTER", cone);
                cmd.Parameters.AddWithValue("@idpac", idpac);
                cmd.Parameters.AddWithValue("@transaccion", transaccion);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewCitaPaciente vre = new ViewCitaPaciente();
                    vre.transaccion = reader["Transaccion"].ToString();
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    vre.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                    vre.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
                    vre.medico = reader["Medico"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
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

        public List<ViewCitaPaciente> getReservaPaciente(string idpac)
        {
            List<ViewCitaPaciente> list = new List<ViewCitaPaciente>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_RESERVA_PACIENTE", cone);
                cmd.Parameters.AddWithValue("@idpac", idpac);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewCitaPaciente vre = new ViewCitaPaciente();
                    vre.transaccion = reader["Transaccion"].ToString();
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    vre.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                    vre.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
                    vre.medico = reader["Medico"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
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

        public List<ViewCitaPaciente> getReservaPacienteFilter(string idpac, string transaccion)
        {
            List<ViewCitaPaciente> list = new List<ViewCitaPaciente>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_RESERVA_PACIENTE_TRANS_FILTER", cone);
                cmd.Parameters.AddWithValue("@idpac", idpac);
                cmd.Parameters.AddWithValue("@transaccion", transaccion);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewCitaPaciente vre = new ViewCitaPaciente();
                    vre.transaccion = reader["Transaccion"].ToString();
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    vre.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                    vre.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
                    vre.medico = reader["Medico"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
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

        public ViewFMPaciente GetFMPacientes(string idpac, string transaccion)
        {
            List<ViewFMPaciente> list = new List<ViewFMPaciente>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
             ViewFMPaciente vre = new ViewFMPaciente();
                cmd = new SqlCommand("PROC_MOSTRAR_FM_PACIENTE", cone);
                cmd.Parameters.AddWithValue("@idpac", idpac);
                cmd.Parameters.AddWithValue("@transaccion", transaccion);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                   
                    vre.observacion = reader["Observacion"].ToString().Trim();
                    vre.receta = reader["Receta"].ToString();
                    vre.alergia = reader["Alergia"].ToString();
                    vre.peso = reader["Peso"].ToString();
                    vre.estatura = reader["Estatura"].ToString();
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    
                }
            cone.Close();

            return vre;
        }

        public double getSaldoPaciente(string idpac)
        {
            double saldoPaciente = 0;
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            ViewFMPaciente vre = new ViewFMPaciente();
            cmd = new SqlCommand("PROC_MOSTRAR_SALDO_PACIENTE", cone);
            cmd.Parameters.AddWithValue("@idpac", idpac);
            cmd.CommandType = CommandType.StoredProcedure;
            reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                saldoPaciente = double.Parse(reader["Saldo"].ToString());
            }
            cone.Close();

            return saldoPaciente;
        }

        public int saveReservaVirtual(Reserva res)
        {
            SqlCommand cmd = new SqlCommand("PROC_RESERVA_PACIENTE_VIRTUAL", cone);
            cmd.Parameters.AddWithValue("@idpac", res.idpaciente);
            cmd.Parameters.AddWithValue("@idcons", res.idconsulta);
            cmd.Parameters.AddWithValue("@fcita", res.fechacita);
            cmd.Parameters.AddWithValue("@idtransaccion", res.idtransicion);
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
    }
}