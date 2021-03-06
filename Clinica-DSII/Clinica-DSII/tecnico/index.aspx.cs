using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Clinica_DSII.tecnico
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string cargo = Session["sessioncargo"] as string;

            if(cargo == null || cargo != "tecnico")
            {
                Response.Redirect("/login");
            }

            lblScargo.Text = Session["sessioncargo"] as string;
            lblSNombre.Text = Session["sesionusuario"] as string;
        }

        protected void btnCerrar_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("/login");
        }
    }
}