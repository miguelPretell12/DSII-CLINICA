using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.ViewClass
{
    public class ViewPacienteSaldo
    {
        public int idpacientes { get; set; }
        public string paciente { get; set; }
        public string dni { get; set; }
        public string correo { get; set; }
        public double saldo { get; set; }

        public ViewPacienteSaldo() { }
    }
}