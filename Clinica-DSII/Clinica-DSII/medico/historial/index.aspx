<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.medico.historial.index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="pdf" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dashboard">
        <div class="panel">
            <div class="cabecera">
                <h1>Clinica Izaguirre</h1>
            </div>
            <ul class="lista-servicio">
                <li><a href="/medico/citas/index">Citas Médicas</a></li>
                <li><a href="/medico/historial/index">Historial Médica</a></li>
            </ul>
        </div>
        <div class="contenido container"> 
            <h1>Citas Programadas</h1>
        <div class="row row-cols-1 row-cols-md-3">
            <div class="col">
                <div class="my-3">
                    <label>Buscar Fecha de cita</label>
                    <input type="date" class="form-control" id="fcita"/>
                </div>
                <a class="btn btn-secondary" href="../index.aspx">Volver</a>
                <input type="submit" class="btn btn-success" id="buscar" value="Buscar Cita" />
            </div>
            <div class="col">

            </div>
        </div>
        <div class="table-responsive mt-3">
            <table class="table" id="tblreserva">
                <thead class="table-dark">
                    <tr>
                        <th>N° Transacción</th>
                        <th>Fecha de cita</th>
                        <th>Horario</th>
                        <th>Paciente</th>
                        <th>D.N.I.</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        </div>
    </div>

    <script type="text/javascript">
        const tblreserva = document.querySelector("#tblreserva tbody");

        listar();

        $(document).on('click', '#buscar', function (e) {
            e.preventDefault();
            const fcita = document.querySelector("#fcita").value;
            if (fcita == "") {
                listar()
            } else {
                const data = { fcita }
                listarfilter(data)
            }
        })

        function listar() {
            $.ajax({
                type: 'POST',
                url: '/medico/historial/index.aspx/getcitamedico',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    const { d } = e;
                    limpiarTabla()
                    d.forEach((x) => {
                        const { transaccion, fcita, horainicio, horafinal, paciente, dni, estado } = x;
                        const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                        const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                        const tr = document.createElement("tr");
                        tr.innerHTML = `
                            <td>${transaccion}</td>
                            <td>${fechaConvert(fcita)}</td>
                            <td>${horai} - ${horaf}</td>
                            <td>${paciente}</td>
                            <td>${dni}</td>
                            <td><span class="badge bg-${estado.toLowerCase() == 'concluido' ? 'success' : 'warning text-dark'}" >${estado}</span></td>
                        `
                        tblreserva.appendChild(tr)
                    })
                }
            })
        }

        function listarfilter(data) {
            $.ajax({
                type: 'POST',
                url: '/medico/historial/index.aspx/getfiltercitamedico',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;
                    limpiarTabla()
                    d.forEach((x) => {
                        const { transaccion, fcita, horainicio, horafinal, paciente, dni, estado } = x;
                        const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                        const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                        const tr = document.createElement("tr");
                        tr.innerHTML = `
                            <td>${transaccion}</td>
                            <td>${fechaConvert(fcita)}</td>
                            <td>${horai} - ${horaf}</td>
                            <td>${paciente}</td>
                            <td>${dni}</td>
                            <td><span class="badge bg-${estado.toLowerCase() == 'concluido' ? 'success' : 'warning text-dark'}" >${estado}</span></td>
                        `
                        tblreserva.appendChild(tr)
                    })
                }
            })
        }

        function limpiarTabla() {
            while (tblreserva.firstChild) {
                tblreserva.removeChild(tblreserva.firstChild)
            }
        }
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
