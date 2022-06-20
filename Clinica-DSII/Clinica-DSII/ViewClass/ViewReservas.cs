using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.ViewClass
{
    public class ViewReservas
    {
        //idtransicion, especialidad, medico, paciente, precio, fcita, freserva, estado
        public string idtransicion { get; set; }
        public string especialidad { get; set; }
        public string medico { get; set; }
        public string paciente { get; set; }
        public double precio { get; set; }
        public DateTime fcita { get; set; }
        public DateTime freserva { get; set; }
        public string estado { get; set; }

        public ViewReservas() { }
    }
}