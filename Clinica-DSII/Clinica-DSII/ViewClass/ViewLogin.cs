using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_DSII.ViewClass
{
    public class ViewLogin
    {
        public string usuarios { get; set; }
        public string cargo { get; set; }
        public string idusuario { get; set; }

        public ViewLogin() { }

        public string getIdUsuario()
        {
            return HttpContext.Current.Session["idusuario"] as string;
        }
    }
}