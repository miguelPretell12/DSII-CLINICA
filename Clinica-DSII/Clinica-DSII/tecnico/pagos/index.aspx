<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.tecnico.pagos.index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="pdf" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard">
        <div class="panel">
            <div class="cabecera">
                <h1>Clinica Izaguirre</h1>
            </div>
            <ul class="lista-servicio">
                <li><a href="/tecnico/pacientes/index">Pacientes</a></li>
                <li><a href="/tecnico/citamedica/consultahorario">Citas Medicas</a></li>
                <li><a href="/tecnico/reservasgeneral/index">Reserva general</a></li>
                <li><a href="/tecnico/reservas/index">Reserva consulta</a></li>
                <li><a href="/tecnico/pagos/index">Pago Reservas Online</a></li>
            </ul>
        </div>
        <div class="contenido container"> 
            <h2 class="mt-3">Reserva - Pagos</h2>
            <div class="d-flex">
              <div style="margin-right: 20px">
               <label>Buscar reserva - N° Transacción </label>
               <input type="text" class="form-control" id="transaccion" />
              </div>
              <div style="display:flex; align-items:end">
               <input type="submit" class="btn btn-success" value="Buscar" id="buscar" />
               <a class="mx-2 btn btn-secondary" href="../index.aspx">Volver</a>
              </div>
            </div>

            <div id="resultado" class="mt-3">

            </div>
        </div>
    </div>

    <script type="text/javascript">
        const resultado = document.querySelector("#resultado");

        $(document).on("click", "#buscar", function (e) {
            e.preventDefault();
            const transaccion = $("#transaccion").val();
            if (transaccion == "") {
                swal("Error!!!", "Completar todos los campos", "error");
                return;
            }
            const data = { transaccion }

            mostrarReserva(data)
        })

        function mostrarReserva(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/pagos/index.aspx/mostrarReservas',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { paciente, medico, fechacita, especialidad, horainicio, horafinal, tipopago, transaccion, dni, precio } = e.d;

                    if (transaccion == null) {
                        resultado.innerHTML = `
                         <div class="row row-cols-1 row-cols-md-3">
                            <div class="alert alert-primary text-capitalize">La reserva que busca ya ha sido validado o cancelada</div>
                        </div>
                        `;
                    } else {
                        const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                        const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                        resultado.innerHTML = `
                         <h4>N° Transaccion: <span>${transaccion}</span></h4>
                         <div>
                            <h3 class="text-decoration-underline">Datos de la Reserva</h3>
                            <p class="m-0 text-capitalize">Médico: <span class="fw-bold">${medico}</span></p>
                            <p class="m-0 text-capitalize">Especialidad: <span class="fw-bold">${especialidad}</span></p>
                            <p class="m-0">Fecha de la cita: <span class="fw-bold">${fechaConvert(fechacita)}</span></p>
                            <p class="m-0">Horario de la cita: <span class="fw-bold">${horai} - ${horaf}</span></p>
                            <p class="m-0">Precio de la consulta: <span class="fw-bold">${parseFloat(precio).toFixed(2)}</span></p>
                            <p class="m-0 text-capitalize">Tipo de pago: <span class="fw-bold">${tipopago.toLowerCase()}</span></p>
                            <hr />
                            <p class="m-0 text-capitalize">Paciente: <span class="fw-bold">${paciente}</span></p>
                            <p class="m-0 text-capitalize">D.N.I. : <span class="fw-bold">${dni}</span></p>
                         </div>
                         <div class="row row-cols-1 row-cols-md-3">
                            <div class="form-group my-2">
                              <input type="hidden" id="transaccion" value="${transaccion}" />
                              <input type="hidden" id="precioc" value="${precio}" />
                              <label>Monto Entregado</label>
                              <input type="number" step="0.01" min="0" class="form-control" id="montoentregado" />
                            </div>
                         </div>
                         <div>
                            <input type="button" value="Validar Reserva" class="btn btn-success" id="validate" />
                         </div>
                        `;
                    }
                }
            })
        }

        $(document).on('click', '#validate', function (e) {
            e.preventDefault();
            const montoentregado = $("#montoentregado").val();
            const precioconsulta = $("#precioc").val();
            const transaccion = $("#transaccion").val();

            if (parseFloat(montoentregado) < parseFloat(precioconsulta)) {
                swal("Error!!!", "El monto entregado debe ser mayor al precio de la consulta", "error");
                return;
            }

            const data = { montoentregado, transaccion }

            $.ajax({
                type: 'POST',
                url: '/tecnico/pagos/index.aspx/validateReserva',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;

                    if (d) {
                        resultado.innerHTML = ``;
                        swal('Exito!!!', 'Se valido y se guardo con exito la reserva', 'success')
                    } else {
                        swal("Error!!!","No se puso validar la reserva","error")
                    }
                }
            })
        })
        function fechaConvert(fechas) {
            const fechanac = fechas.split('/');
            const fecha1 = fechanac[1].split('Date');
            const fecha2 = fecha1[1].split(')');
            const fecha3 = fecha2[0].split('(');
            const fechan = parseInt(fecha3[1]);
            const fecha = new Date(fechan);
            const fechares = fecha.getDate() + '/' + (fecha.getMonth() + 1) + '/' + fecha.getFullYear();
            return fechares;
        }
    </script>
</asp:Content>
