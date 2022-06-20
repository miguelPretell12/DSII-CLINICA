<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.tecnico.reservas.index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
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
            <h1>Reportes de Reservas</h1>
            <div class="d-flex align-items-center">
                <div class="me-5">
                    <label>Fecha inicio</label>
                    <input type="date" id="fechainicio" class="form-control" />
                </div>
    
                <div class="me-5">
                    <label>Fecha final</label>
                    <input type="date" id="fechafinal" class="form-control" />
                </div>
    
                <div class="d-flex align-self-end">
                    <input type="submit" id="buscar" class="btn btn-primary" />
                    <a href="../index.aspx" class="btn btn-secondary mx-2">Volver</a>
                </div>
            </div>
            <div class="table-responsive">
                <table id="tablereserva" class="table">
                    <thead>
                        <tr>
                            <th>N° Transacción</th>
                            <th>Especialidad</th>
                            <th>Medico</th>
                            <th>Paciente</th>
                            <th>Precio</th>
                            <th>Fecha de Reserva</th>
                            <th>Fecha de Cita</th>
                            <th>Horario</th>
                            <th>Estado</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        const tablecontenedor = document.querySelector("#tablereserva tbody");

        document.addEventListener('DOMContentLoaded', function () {
            listar();
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

        $(document).on('click', '#buscar', function (e) {
            e.preventDefault();
            const finicio = document.querySelector("#fechainicio").value;
            const ffinal = document.querySelector("#fechafinal").value;
            if (finicio > ffinal || ffinal < finicio) {
                swal('Error','la fecha inicio debe ser menor a la fecha final o viceversa','error')
                return
            }
            const data = { finicio, ffinal }

            listarFilterDate(data)
        })

        function listar() {
            $.ajax({
                type: 'POST',
                url: '/tecnico/reservas/index.aspx/getreservas',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    console.log(e)
                    const { d } = e;
                    limpiarTabla()
                    d.forEach((res) => {
                        const { transaccion, medico, paciente, dni, especialidad, precio, estado, horainicio, horafinal, freserva, fcita } = res;
                        const tr = document.createElement("tr");
                        const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                        const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                        tr.innerHTML = `
                          <td>${transaccion}</td>
                          <td>${especialidad}</td>
                          <td>${medico}</td>
                          <td>${paciente}</td>
                          <td>${precio}</td>
                          <td>${fechaConvert(freserva)}</td>
                          <td>${fechaConvert(fcita)}</td>
                          <td>${horai} - ${horaf}</td>
                          <td><span class="badge bg-${estado.toLowerCase() == 'concluido' ? 'success' : 'warning text-dark'}" >${estado}</span></td>
                          <td></td>
                         `;

                        tablecontenedor.appendChild(tr);
                    })
                }
            })
        }

        function listarFilterDate(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/reservas/index.aspx/getReservasFiltroFecha',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    console.log(e)
                    const { d } = e;
                    limpiarTabla()
                    d.forEach((res) => {
                        const { transaccion, medico, paciente, dni, especialidad, precio, estado, horainicio, horafinal, freserva, fcita } = res;
                        const tr = document.createElement("tr");
                        const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                        const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                        tr.innerHTML = `
                          <td>${transaccion}</td>
                          <td>${especialidad}</td>
                          <td>${medico}</td>
                          <td>${paciente}</td>
                          <td>${precio}</td>
                          <td>${fechaConvert(freserva)}</td>
                          <td>${fechaConvert(fcita)}</td>
                          <td>${horai} - ${horaf}</td>
                          <td><span class="badge bg-${estado.toLowerCase() == 'concluido' ? 'success' : 'warning text-dark'}" >${estado}</span></td>
                          <td></td>
                         `;

                        tablecontenedor.appendChild(tr);
                    })
                }
            })
        }

        function limpiarTabla() {
            while (tablecontenedor.firstChild) {
                tablecontenedor.removeChild(tablecontenedor.firstChild)
            }
        }
    </script>
</asp:Content>
