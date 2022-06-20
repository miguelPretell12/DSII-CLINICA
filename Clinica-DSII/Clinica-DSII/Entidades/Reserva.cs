using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.Entidades
{
    public class Reserva
    {
        public int idreserva { get; set; }
        public int idpaciente { get; set; }
        public int idconsulta { get; set; }
        public DateTime fechareserva { get; set; }
        public DateTime fechacita { get; set; }
        public double montoentregado {get; set;}
        public string idtransicion { get; set; }
        public string estado { get; set; }


        public Reserva() { }
    }
}