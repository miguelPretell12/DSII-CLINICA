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
    public class DaoPDF
    {
        private SqlConnection cone = new SqlConnection("Server=LAPTOP-OB4D3M28; Database=clinicaDSII; Integrated Security=true");

        public ViewTransaccion obtenerTransaccion(string transaccion)
        {
            ViewTransaccion vtr = new ViewTransaccion();

            SqlCommand cmd = null;
            SqlDataReader reader = null;
            cone.Open();
            cmd = new SqlCommand("PROC_BUSCAR_TRANSACCION", cone);
            cmd.Parameters.AddWithValue("@transaccion", transaccion);
            cmd.CommandType = CommandType.StoredProcedure;
            reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                vtr.transaccion = reader["Transaccion"].ToString();
                vtr.medico = reader["Medico"].ToString();
                vtr.paciente = reader["Paciente"].ToString();
                vtr.dni = reader["Dni"].ToString();
                vtr.especialidad = reader["Especialidad"].ToString();
                vtr.precio = reader["Precio"].ToString();
                vtr.estado = reader["Estado"].ToString();
                vtr.horainicio = TimeSpan.Parse(reader["Horainicio"].ToString());
                vtr.horafinal = TimeSpan.Parse(reader["Horafinal"].ToString());
                vtr.freserva = DateTime.Parse(reader["freserva"].ToString());
                vtr.fcita = DateTime.Parse(reader["fcita"].ToString());
            }
            cone.Close();

            return vtr;
        }
    }
}