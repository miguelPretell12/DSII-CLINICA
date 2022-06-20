using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.ViewClass
{
    public class ViewPacienteReserva
    {
        public string transaccion { get; set; }
        public string medico { get; set; }
        public string especialidad { get; set; }
        public DateTime fcita { get; set; }
        public TimeSpan hinicio { get; set; }
        public TimeSpan hfinal { get; set; }
        public Double precio { get; set; }
        public string estado { get; set; }

        public ViewPacienteReserva() { }
    }
}