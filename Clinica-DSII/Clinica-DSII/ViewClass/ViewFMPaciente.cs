using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.ViewClass
{
    public class ViewFMPaciente
    {
        public string observacion { get; set; }
        public string receta { get; set; }
        public string alergia { get; set; }
        public string peso { get; set; }
        public string estatura { get; set; }
        public DateTime fcita { get; set; }
        public ViewFMPaciente() { }
    }
}