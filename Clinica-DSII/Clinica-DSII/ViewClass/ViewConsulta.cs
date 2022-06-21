using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.ViewClass
{
    public class ViewConsulta
    {
        public int idconsulta { get; set; }
        public int medico { get; set; }
        public int horario { get; set; }
        public int idespecialidad { get; set; }
        public string especialidad { get; set; }
        public double precio { get; set; }
        public ViewConsulta() { }
    }
}