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

namespace Clinica_DSII.tecnico.pagos
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static ViewMostrarReserva mostrarReservas(string transaccion)
        {
            DaoTecnicoReserva dao = new DaoTecnicoReserva();
            return dao.mostrarConsultaTransaccion(transaccion);
        }

        [WebMethod]
        public static int validateReserva(string montoentregado, string transaccion)
        {
            DaoTecnicoReserva dao = new DaoTecnicoReserva();
            double montoe = double.Parse(montoentregado);

            return dao.validarReservas(transaccion, montoe);
        }
    }
}