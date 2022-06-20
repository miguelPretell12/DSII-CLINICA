using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.ViewClass
{
    public class ViewReservaMedico
    {
        public int idreserva { get; set; }
        public string medico { get; set; }
        public string paciente { get; set; }
        public string dni { get; set; }
        public string estado { get; set; }
        public string especialidad { get; set; }
        public string transaccion { get; set; }
        public ViewReservaMedico() { }
    }
}