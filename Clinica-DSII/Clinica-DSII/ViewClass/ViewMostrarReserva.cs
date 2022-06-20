using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.ViewClass
{
    public class ViewMostrarReserva
    {
        public string paciente { get; set; }
        public string medico { get; set; }
        public DateTime fechacita { get; set; }
        public string especialidad { get; set; }
        public TimeSpan horainicio { get; set; }
        public TimeSpan horafinal { get; set; }
        public string tipopago { get; set; } 
        public string transaccion { get; set; }
        public string dni { get; set; }
        public double precio { get; set; }
        public ViewMostrarReserva() { }
    }
}