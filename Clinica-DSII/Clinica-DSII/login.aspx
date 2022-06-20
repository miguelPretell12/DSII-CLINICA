<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Clinica_DSII.login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-2">
        <div class="caja-login">
            <img src="img/logo.png" class="imagen-login" />
            <h2 class="text-center text-white">Iniciar Session</h2>
            <div class="caja-input">
                <div class="email">
                    <label>Correo Electronico</label>
                    <input type="email" id="correo"/>
                </div>
                <div class="password">
                    <label>Contraseña</label>
                    <input type="password" id="password">
                </div>
            </div>
            <input type="submit" class="boton" id="btnInicio" value="Iniciar Session">
        </div>
    </div>

    <script>
        $(document).on('click', '#btnInicio', function (e) {
            e.preventDefault();
            const correo = $("#correo").val();
            const password = $("#password").val();

            const data = {
                correo, password
            }
            login(data)
        });

        function login(data) {
            $.ajax({
                type: 'POST',
                url: '/login.aspx/Login',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    console.log(e)
                    const { cargo, idusuario, usuarios } = e.d;
                    if (idusuario == null) {
                        swal('Error!!', 'Datos incorrectos o cuenta bloqueada', 'error');
                    } else {
                        if (cargo == 'administrador') {
                            window.location.href = "/dashboard/admin";
                        }
                        else if (cargo == 'tecnico') {
                            window.location.href = "/tecnico/index";
                        }
                        else if (cargo == 'doctor') {
                            window.location.href = "/medico/index";
                        }
                        else if (cargo == 'paciente') {
                            window.location.href = "/paciente/index";
                        }
                    }
                }
            })
        }
    </script>
</asp:Content>
