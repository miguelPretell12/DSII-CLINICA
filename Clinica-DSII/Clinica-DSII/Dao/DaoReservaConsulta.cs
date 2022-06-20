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
    public class DaoReservaConsulta
    {
        private SqlConnection cone = new SqlConnection("Server=LAPTOP-OB4D3M28; Database=clinicaDSII; Integrated Security=true");

        public List<ViewConsultasDisponibles> listarConsultasHorarios(int idhorario)
        {
            List<ViewConsultasDisponibles> list = new List<ViewConsultasDisponibles>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_BUSCAR_HORARIOS_CONSULTAS", cone);
                cmd.Parameters.AddWithValue("@idhorario", idhorario);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewConsultasDisponibles hor = new ViewConsultasDisponibles();
                    hor.idconsulta = int.Parse(reader["Consultaid"].ToString());
                    hor.medico = reader["Medico"].ToString();
                    hor.especialidad = reader["Especialidad"].ToString();
                    hor.precio = double.Parse(reader["Precio"].ToString());
                    hor.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                    hor.horafinal = TimeSpan.Parse(reader["Horafin"].ToString());
                    list.Add(hor);
                }
            }
            catch (Exception e)
            {

            }
            cone.Close();

            return list;
        }
    
        public Paciente searchPaciente(string dni)
        {
            Paciente pac = new Paciente();

            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            cmd = new SqlCommand("PROC_OBTENER_PAC_DNI", cone);
            cmd.Parameters.AddWithValue("@dni", dni);
            cmd.CommandType = CommandType.StoredProcedure;
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
            cone.Close();

            return pac;
        }

        public ViewPacienteSaldo searchPacienteSaldo(string dni)
        {
            ViewPacienteSaldo pac = new ViewPacienteSaldo();

            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            cmd = new SqlCommand("PROC_OBTENER_PAC_DNI_SALDO", cone);
            cmd.Parameters.AddWithValue("@dni", dni);
            cmd.CommandType = CommandType.StoredProcedure;
            reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                pac.idpacientes = int.Parse(reader["Idpacientes"].ToString());
                pac.paciente = reader["Paciente"].ToString();
                pac.dni = reader["Dni"].ToString();
                pac.correo = reader["Correo"].ToString();
                pac.saldo = double.Parse(reader["Saldo"].ToString());
            }
            cone.Close();

            return pac;
        }

        public int save(Reserva res) {
            SqlCommand cmd = new SqlCommand("PROC_INSERTAR_RESERVA_TECNICO", cone);
            cmd.Parameters.AddWithValue("@idpaciente", res.idpaciente);
            cmd.Parameters.AddWithValue("@idconsulta", res.idconsulta);
            cmd.Parameters.AddWithValue("@fechacita", res.fechacita);
            cmd.Parameters.AddWithValue("@montoentregado", res.montoentregado);
            cmd.Parameters.AddWithValue("@idtransicion", res.idtransicion);
            cmd.CommandType = CommandType.StoredProcedure;


            cone.Open(); // Abrir la conexion al servidor
            int rpt=cmd.ExecuteNonQuery(); // Enviar la orden al servidor

            cone.Close(); // Cerrar la conexion al servidor
            cmd.Dispose(); // Liberar recursos del comando            

            return rpt;
        }

        public int recargaPac(int idpac, double saldo)
        {
            SqlCommand cmd = new SqlCommand("PROC_RECARGA_PACIENTE", cone);
            cmd.Parameters.AddWithValue("@idpac", idpac);
            cmd.Parameters.AddWithValue("@saldo", saldo);
            cmd.CommandType = CommandType.StoredProcedure;


            cone.Open(); // Abrir la conexion al servidor
            int rpt = cmd.ExecuteNonQuery(); // Enviar la orden al servidor

            cone.Close(); // Cerrar la conexion al servidor
            cmd.Dispose(); // Liberar recursos del comando            

            return rpt;
        }

        public List<ViewReservas> listarReservas()
        {
            List<ViewReservas> list = new List<ViewReservas>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LISTAR_TRANSICION_RESERVAS", cone);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewReservas vre = new ViewReservas();
                    vre.idtransicion = reader["Transicion"].ToString();
                    vre.medico = reader["Medico"].ToString();
                    vre.paciente = reader["Paciente"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
                    vre.precio = double.Parse(reader["Precio"].ToString());
                    vre.estado = reader["Estado"].ToString();
                    vre.freserva = DateTime.Parse(reader["Freserva"].ToString());
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    list.Add(vre);
                }
            }
            catch (Exception e)
            {

            }
            cone.Close();

            return list;
        }

        public List<ViewReservas> buscarTransicion (string transicion)
        {
            List<ViewReservas> list = new List<ViewReservas>();
            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            try
            {
                cmd = new SqlCommand("PROC_LIST_TRANS_RES_BUSCAR", cone);
                cmd.Parameters.AddWithValue("@idtransicion", transicion);
                cmd.CommandType = CommandType.StoredProcedure;
                reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ViewReservas vre = new ViewReservas();
                    vre.idtransicion = reader["Transicion"].ToString();
                    vre.medico = reader["Medico"].ToString();
                    vre.paciente = reader["Paciente"].ToString();
                    vre.especialidad = reader["Especialidad"].ToString();
                    vre.precio = double.Parse(reader["Precio"].ToString());
                    vre.estado = reader["Estado"].ToString();
                    vre.freserva = DateTime.Parse(reader["Freserva"].ToString());
                    vre.fcita = DateTime.Parse(reader["Fcita"].ToString());
                    list.Add(vre);
                }
            }
            catch (Exception e)
            {

            }
            cone.Close();

            return list;
        }

        public void generarPdf()
        {
        }
    }
}