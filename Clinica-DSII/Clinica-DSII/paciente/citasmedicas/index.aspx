<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.paciente.citasmedicas.index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard">
        <div class="panel">
            <div class="cabecera">
                <h1>Clinica Izaguirre</h1>
            </div>
            <ul class="lista-servicio">
               <li><a href="/paciente/citasmedicas/index">Citas Médicas</a></li>
                <li><a href="/paciente/reserva/index">Crear reservas</a></li>
            </ul>
        </div>
        <div class="contenido container"> 
            <h2>Citas médica - Observaciones</h2>
            <div class="">
                <div class="row">
                    <div class="col">
                        <label>Buscar por N° Transaccion</label>
                        <input type="text" placeholder="tu n° transaccion" id="transaccion" class="form-control"/>
                    </div>
                </div>
                <div class="mt-3">
                    <a class="btn btn-secondary" href="../index.aspx">Volver</a>
                    <input type="button" class="btn btn-primary" value="buscar" id="buscar" />
                </div>
            </div>
            <div class="table-responsive">
                <table class="table" id="tblhistorial">
                    <thead>
                        <tr>
                            <th>N° Transaccion</th>
                            <th>Especialidad</th>
                            <th>Horario</th>      
                            <th>Médico</th>
                            <th>Fecha de cita</th>
                            <th>Estado de pago</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalhistorial" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content ">
          <div class="modal-header bg-dark bg-gradient">
            <h5 class="modal-title text-white " id="exampleModalLabel">Observacion de la cita</h5>
            <button type="button" class="btn-close text-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body" id="historial">
              
          </div>
          <div class="modal-footer bg-dark bg-gradient">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <script type="text/javascript">
        const tblhistorial = document.querySelector("#tblhistorial tbody");
        const historial = document.querySelector("#historial")
        listarHistorial()

        $(document).on('click', "#buscar", function (e) {
            e.preventDefault();
            const transaccion = document.querySelector("#transaccion").value;
            if (transaccion == '') {
                listarHistorial();
            } else {
                const data = { transaccion }
                listarHistorialFilter(data)
            }
        })

        function listarHistorialFilter(data) {
            $.ajax({
                type: 'POST',
                url: '/paciente/citasmedicas/index.aspx/getHistorialFilter',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;
                    limpiarTabla()
                    d.forEach((x) => {
                        const { transaccion, especialidad, medico, horainicio, horafinal, fcita, estado } = x;
                        const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                        const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                        const tr = document.createElement("tr");
                        tr.innerHTML = `
                            <td>${transaccion}</td>
                            <td>${especialidad}</td>
                            <td>${horai} - ${horaf}</td>
                            <td>${medico}</td>
                            <td>${fechaConvert(fcita)}</td>
                            <td><span class="badge bg-${estado.toLowerCase() == 'concluido' ? 'success' : 'warning text-dark'}" >${estado}</span></td>
                            <td>
                                <button type="button"
                                id="btnVer"
                                data-bs-toggle="modal" data-bs-target="#modalhistorial"
                                class="btn btn-danger" data-transaccion="${transaccion}" ${estado.toLowerCase() == 'concluido' ? '' : 'disabled'}>Ver Observaciones de la cita</button>
                            </td>
                            `
                        tblhistorial.appendChild(tr)
                    })
                }
            })
        }

        $(document).on("click", "#btnVer", function (e) {
            const transaccion = e.target.dataset.transaccion;
            const data = { transaccion };
            console.log(data)
            getTransaccionFM(data)
        })

        function getTransaccionFM(data) {
            $.ajax({
                type: 'POST',
                url: '/paciente/citasmedicas/index.aspx/GetFMPacientes',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { observacion, receta, alergia, peso, estatura, fcita } = e.d;
                    if (observacion == null) {
                        historial.innerHTML = `
                        <div class="alert alert-primary text-center">Las observaciones de la cita, no han sido guardadas</div>
                        `
                    } else {
                        historial.innerHTML = `
                            <p class="mt-0">Fecha de cita: <span class="fw-bold" id="fcita">${fechaConvert(fcita)}</span></p>
                              <hr />
                            <div class="form-group">
                                <h3>Observaciones de la cita:</h3>
                                <p id="observacion">${observacion}</p>
                            </div>
                            <div class="form-group">
                                <h3>Receta de la cita:</h3>
                                <p id="receta">${receta}</p>
                            </div>
                              <hr />
                            <div class="form-group">
                                <h4>Datos del paciente</h4>
                                <p>¿Eres alergico a los medicamentos? <span class="fw-bold badge bg-${alergia.toLowerCase() == 'si' ? 'danger' : 'success'} " id="alergia">${alergia.toUpperCase()}</span></p>
                                <p>Peso: <span class="fw-bold">${peso}Kg</span></p>
                                <p>Estatura: <span class="fw-bold" id="estatura">${estatura}mtrs</span></p>
                            </div>
                            ` ;
                    }
                    
                    
                }
            })
        }

        function listarHistorial() {
            $.ajax({
                type: 'POST',
                url: '/paciente/citasmedicas/index.aspx/getHistorial',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    const { d } = e;
                    d.forEach((x) => {
                        const { transaccion, especialidad, medico, horainicio, horafinal, fcita, estado } = x;
                        const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                        const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                        const tr = document.createElement("tr");
                        tr.innerHTML = `
                            <td>${transaccion}</td>
                            <td>${especialidad}</td>
                            <td>${horai} - ${horaf}</td>
                            <td>${medico}</td>
                            <td>${fechaConvert(fcita) }</td>
                            <td><span class="badge bg-${estado.toLowerCase() == 'concluido' ? 'success' : 'warning text-dark'}" >${estado}</span></td>
                            <td>
                                <button type="button"
                                data-bs-toggle="modal" data-bs-target="#modalhistorial"
                                class="btn btn-danger" id="btnVer" data-transaccion="${transaccion}" ${estado.toLowerCase() == 'concluido' ? '' : 'disabled'}>Ver Observaciones de la cita</button>
                            </td>
                            `
                        tblhistorial.appendChild(tr)
                    })
                }
            })
        }

        function limpiarTabla() {
            while (tblhistorial.firstChild) {
                tblhistorial.removeChild(tblhistorial.firstChild)
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
