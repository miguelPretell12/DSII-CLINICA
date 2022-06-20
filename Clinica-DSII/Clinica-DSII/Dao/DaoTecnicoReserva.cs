using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Clinica_DSII.ViewClass;
using System.Data.SqlClient;

namespace Clinica_DSII.Dao
{
    public class DaoTecnicoReserva
    {
        private SqlConnection cone = new SqlConnection("Server=LAPTOP-OB4D3M28; Database=clinicaDSII; Integrated Security=true");
    
        public ViewMostrarReserva mostrarConsultaTransaccion(string transac)
        {
            ViewMostrarReserva vmr = new ViewMostrarReserva();
            SqlCommand cmd = new SqlCommand("PROC_CONSULTAR_RESERVA", cone);
            cmd.Parameters.AddWithValue("@trasanccion", transac);
            cmd.CommandType = CommandType.StoredProcedure;
            cone.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if(reader.Read())
            {
                vmr.paciente = reader["Paciente"].ToString();
                vmr.medico = reader["Medico"].ToString();
                vmr.fechacita = DateTime.Parse(reader["Fechacita"].ToString());
                vmr.especialidad = reader["Especialidad"].ToString();
                vmr.tipopago = reader["Tipopago"].ToString();
                vmr.transaccion = reader["Transaccion"].ToString();
                vmr.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                vmr.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
                vmr.precio = double.Parse(reader["Precio"].ToString());
                vmr.dni = reader["Dni"].ToString();
            }
            cone.Close();
            return vmr;
        }

        public int validarReservas(string transac, double montoe)
        {
            SqlCommand cmd = new SqlCommand("PROC_VALIDAR_RESERVAS", cone);
            cmd.Parameters.AddWithValue("@transaccion", transac);
            cmd.Parameters.AddWithValue("@montoe", montoe);
            cmd.CommandType = CommandType.StoredProcedure;
            cone.Open(); // Abrir la conexion al servidor
            int rpta = cmd.ExecuteNonQuery(); // Enviar la orden al servidor
            cone.Close(); // Cerrar la conexion al servidor
            cmd.Dispose();

            return rpta;
        }
    }
}