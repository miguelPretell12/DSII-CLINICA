using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.ViewClass
{
    public class ViewCitaMedico
    {
        public string transaccion { get; set; }
        public string estado { get; set; }
        public string dni { get; set; }
        public string paciente { get; set; }
        public DateTime fcita { get; set; }
        public TimeSpan horainicio { get; set; }
        public TimeSpan horafinal { get; set; }

        public ViewCitaMedico() { }
    }
}