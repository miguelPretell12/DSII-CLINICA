using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Clinica_DSII.ViewClass
{
    public class ViewTransaccion
    {
        public string transaccion;
        public string medico;
        public string paciente;
        public string dni;
        public string especialidad;
        public string precio;
        public string estado;
        public TimeSpan horainicio;
        public TimeSpan horafinal;
        public DateTime freserva;
        public DateTime fcita;

        public ViewTransaccion() { }
    }
}