<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.paciente.reserva.index" %>
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
            <h1>Reservas para un cita</h1>
            <div class="">
                <div class="">
                    <a class="btn btn-secondary" href="../index.aspx">Volver</a>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" >Crear Reservas</button>
                </div>
            </div>
            <h3>Lista de Reservas</h3>
            <div class="table-responsive">
                <table id="tblreservapaciente" class="table">
                    <thead class="table-dark">
                        <tr>
                            <th>N° Transacción</th>
                            <th>Médico</th>
                            <th>Especialidad</th>
                            <th>Fecha de Cita</th>
                            <th>Horario de Cita</th>
                            <th>Precio</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="form-group">
                <label>Fecha de Cita</label>
                <input type="date" class="form-control" id="fcita"/>
            </div>
            <div class="form-group d-flex justify-content-around align-items-center">
                <label>Buscar Consulta</label>
                <button type="button" class="btn btn-primary mt-3" id="fcitabtn" data-bs-toggle="modal" data-bs-target="#listconsulta" disabled>
                    Buscar consulta
                </button>
            </div>
            <div class="form-group my-3" id="consulta-descrip">
            </div>
            <div class="form-group">
                <label class="fw-bold">Tipo de Pago</label>
                <div class="d-flex">
                     <div class="mx-2">
                       <label>Presencial</label>
                       <input type="radio" name="rdpresencial" value="efectivo"/>
                     </div>
                     <div>
                       <label>Virtual</label>
                       <input type="radio" name="rdpresencial" value="virtual"/>
                     </div>
                 </div>
                <div id="saldo">

                </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary" id="guardar">Reservar</button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal - Listar Consulta -->
    <div class="modal fade" id="listconsulta" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="">Modal title</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
              <div class="form-group">
                  
                  <div class="my-3">
                    <label>Horario</label>
                     <select class="form-control" id="horarios">
                         <option>--seleccione--</option>
                     </select>
                  </div>
                  <div class="my-3">
                      <label>Especialidad</label>
                      <select class="form-control" id="especialidads">
                          <option>--seleccione--</option>
                      </select>
                  </div>
                  <input type="button" class="btn btn-success my-3" value="Buscar" id="buscar" />
              </div>
            <div class="form-group">
                <ul class="list-group" id="listadoConsulta">
                    
                </ul>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" data-bs-toggle="modal" data-bs-target="#exampleModal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <script>
        const tblpacres = document.querySelector("#tblreservapaciente tbody");
        const horario = document.querySelector("#horarios");
        const especialidad = document.querySelector("#especialidads");
        const listaconsulta = document.querySelector("#listadoConsulta");
        const mtsaldo = document.querySelector("#saldo")

        $(document).on('change', '#fcita', function (e) {
            const value = e.target.value;
            const btnfc = document.querySelector("#fcitabtn")
            if (value == '') {
                btnfc.disabled = true;
            } else {
                btnfc.disabled = false
            }
        })

        document.addEventListener('DOMContentLoaded', function (e) {
            horarios()
            especialidads()
            listar()    
        })

        document.querySelector('#guardar').addEventListener('submit', function (e) {
            e.preventDefault();
            console.log(1)
        }) 

        /*$(document).on("submit", "guardar", function (e) {
            e.preventDefault();
            console.log(2)
        })*/

        $(document).on('click', 'input[name="rdpresencial"]:checked', function (e) {
            console.log(e.target.value)
            if (e.target.value == 'virtual') {
                mostrarSaldo();
            } else {
                mtsaldo.innerHTML = ``
            }
        })
        
        $(document).on('click', '#buscar', function (e) {
            e.preventDefault();
            const horario = document.querySelector("#horarios").value;
            const especialidad = document.querySelector("#especialidads").value;
            const fechacita = document.querySelector("#fcita").value;
            const data = {
                idesp: especialidad,
                idhor: horario,
                fechacita: fechacita
            }

            getObtenerConsulta(data);

        })
        
        $(document).on('click', "#obtenerConsulta", function (e) {
            const idcons = e.target.dataset.idconsulta;
            const modalEsp = document.querySelector("#esp-modal").textContent;
            const modalMed = document.querySelector("#md-modal").textContent;
            const horMed = document.querySelector("#md-hor").textContent;

            document.querySelector("#consulta-descrip").innerHTML = `
                <h3>Descripción de consulta elegida</h3>
                <hr/>
                <input type="hidden" id="idcons" value="${idcons}"/>
                <p class="m-0" id="consulta">Consulta: <span class="fw-bold">${modalEsp} - ${modalMed}</span></p>
                <p class="m-0" id="horario">Horario: <span class="fw-bold">${horMed}</span></p>
            `;

        })

        $(document).on("click", "#guardar", function (e) {
            e.preventDefault();
            const fcita = document.querySelector("#fcita").value;
            const idcons = document.querySelector("#idcons") == null ? "" : document.querySelector("#idcons").value;
            const tipopago = document.querySelector("input[name='rdpresencial']:checked").value
            if (fcita == "" || idcons == "") {
                swal("Error","Completar todos los campos","error")
                return;
            }
            const data = {
                transaccion: Date.now(),
                fcita,
                idcons
            }
            
            if (tipopago == 'efectivo') {
                guardarResPac(data)
            } else {
                guardarResPacVirtual(data)
                mostrarSaldo()
            }

        })

        function mostrarSaldo() {
            $.ajax({
                type: 'POST',
                url: '/paciente/reserva/index.aspx/mostrarSaldo',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    const { d } = e
                    mtsaldo.innerHTML = `
                    <p class="bg-${parseFloat(d) > 0 ? 'success' : 'danger'} bg-gradient rounded p-2 text-white">Saldo Disponible: <span>${parseFloat(d).toFixed(2)}</span></p>
                    `;
                }
            })
        }

        function guardarResPac(data) {
            $.ajax({
                type: 'POST',
                url: '/paciente/reserva/index.aspx/save',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;
                    if (d) {
                        console.log(data)
                        $("#exampleModal").modal('hide');
                        swal('Exito!!!', 'se guardo con exito la reserva, porfavor acercarse para cancelar tu reserva, para poder tener tu reserva completa', 'success');
                        listar();
                    }
                }
            })
        }

        function guardarResPacVirtual(data) {
            $.ajax({
                type: 'POST',
                url: '/paciente/reserva/index.aspx/saveVirtual',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;
                    if (d) {
                        $("#exampleModal").modal('hide');
                        swal('Exito!!!', 'se guardo con exito la reserva, porfavor recordar su N° de transaccion para asi el medico haga su ficha de la cita', 'success');
                        listar();
                    } else {
                        swal("Error","No tiene saldo suficiente para reservar la cita","error")
                    }
                }
            })
        }

        function getObtenerConsulta(data) {
            $.ajax({
                type: 'POST',
                url: '/paciente/reserva/index.aspx/obtenerConsulta',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;
                    limpiarList();
                    const slist = document.createElement("li");
                    if (d.length > 0) {
                        d.forEach((x) => {
                            const { idconsulta, medico, especialidad, horainicio, horafinal, precio, mensaje } = x;
                            const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                            const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                            const li = document.createElement("li");
                            if (mensaje == '') {
                                li.classList.add('list-group-item', 'd-flex', 'justify-content-between', 'align-items-center');
                                li.innerHTML = `
                                <div>
                                    <p class="m-0">Especialidad: <span class="fw-bold" id="esp-modal">${especialidad}</span></p>
                                    <p class="m-0">Medico: <span class="fw-bold" id="md-modal">${medico}</span></p>
                                    <p class="my-0">Horario: <span class="fw-bold" id="md-hor" >${horai} - ${horaf}</span></p>
                                    <p class="my-0">Precio: <span class="fw-bold">${precio}</span></p>
                                </div>
                                <button type="button" class="btn btn-warning" style="color: #fff" id="obtenerConsulta" data-idconsulta="${idconsulta}" data-bs-toggle="modal" data-bs-target="#exampleModal">v/</button>
                                `
                            } else {
                                li.innerHTML = `
                                <div class="alert alert-danger text-center">
                                    ${mensaje}
                                </div>
                                `;
                            }
                            listaconsulta.appendChild(li);
                        })
                    } else {
                        slist.innerHTML = `
                          <div class="alert alert-danger text-center">
                            La consulta que busca ya ha sido reservada 
                          </div>
                        `;

                        listaconsulta.appendChild(slist);
                    }
                    
                }
            })
        }

        function horarios() {
            $.ajax({
                type: 'POST',
                url: '/tecnico/reservasgeneral/index.aspx/getHorarios',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    const { d } = e;

                    d.forEach((hor) => {
                        const { idhorario, horainicio, horafinal } = hor;
                        const option = document.createElement('option');
                        const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                        const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                        option.value = idhorario;
                        option.textContent = `${horai} : ${horaf}`;

                        horario.appendChild(option);
                    })
                }
            })
        }

        function especialidads() {
            $.ajax({
                type: 'POST',
                url: '/tecnico/reservasgeneral/index.aspx/getEspecialidades',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    const { d } = e;
                    d.forEach((esp) => {
                        const { idespecialidad, nombre } = esp;
                        const option = document.createElement('option');
                        option.value = idespecialidad;
                        option.textContent = nombre;
                        especialidad.appendChild(option);
                    })
                }
            })
        }

        function listar() {
            $.ajax({
                type: 'POST',
                url: '/paciente/reserva/index.aspx/GetViewPacienteReservasId',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    const { d } = e;
                    limpiarTbl();
                    d.forEach((x) => {
                        const { transaccion, medico, especialidad, fcita, hinicio, hfinal, precio, estado } = x;
                        const horai = (hinicio.Hours < 10 ? '0' + hinicio.Hours : hinicio.Hours) + ':' + (hinicio.Minutes < 10 ? '0' + hinicio.Minutes : hinicio.Minutes);
                        const horaf = (hfinal.Hours < 10 ? '0' + hfinal.Hours : hfinal.Hours) + ':' + (hfinal.Minutes < 10 ? '0' + hfinal.Minutes : hfinal.Minutes);
                        const tr = document.createElement("tr");
                        tr.innerHTML = `
                            <td>${transaccion}</td>
                            <td>${medico}</td>
                            <td>${especialidad}</td>
                            <td>${fechaConvert(fcita)}</td>
                            <td>${horai} - ${horaf}</td>
                            <td>S/. ${parseFloat(precio).toFixed(2)}</td>
                            <td><span class="badge bg-${estado.toLowerCase() == 'concluido' ? 'success' : 'warning text-dark'}" >${estado}</span></td>
                            <td><button type="button" class="btn btn-danger" data-transaccion="${transaccion}" id="pdfbtn" ${estado.toLowerCase() == 'concluido' ? '' : 'disabled'}>PDF</button></td>
                        `;
                        tblpacres.appendChild(tr);
                    })
                }
            })
        }

        $(document).on("click", "#pdfbtn", function (e) {
            e.preventDefault();
            const data = { transaccion: e.target.dataset.transaccion }

            window.open(`/tecnico/citamedica/PDF.aspx?transaccion=${data.transaccion}`);
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

        function limpiarTbl() {
            while (tblpacres.firstChild) {
                tblpacres.removeChild(tblpacres.firstChild)
            }
        }

        function limpiarList() {
            while (listaconsulta.firstChild) {
                listaconsulta.removeChild(listaconsulta.firstChild);
            }
        }
    </script>
</asp:Content>
