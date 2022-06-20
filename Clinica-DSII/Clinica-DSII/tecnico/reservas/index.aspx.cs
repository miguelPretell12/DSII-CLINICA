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

namespace Clinica_DSII.tecnico.reservas
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static List<ViewTransaccion> getreservas() {
            DaoReserva dao = new DaoReserva();
            return dao.getTransaccionReservas();
        }

        [WebMethod]
        public static List<ViewTransaccion> getReservasFiltroFecha(string finicio, string ffinal)
        {
            DaoReserva dao = new DaoReserva();
            return dao.getfilterDateReservas(finicio, ffinal);
        }
    }
}