<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.tecnico.reservasgeneral.index" %>
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
            <h1>Reservar citas</h1>
        <div class="">
            <div class="row row-cols-1 row-cols-md-3" id="mostrarcampos">
                <div class="form-group">
                    <label>Horario de consultas</label>
                    <select class="form-control" id="horario">
                        <option value="">--seleccione--</option>
                    </select>
                </div>
                <div>
                    <label>Especialidad</label>
                    <select class="form-control" id="especialidad">
                        <option value="">--seleccione--</option>
                    </select>
                </div>
                <div>
                    <label>Fecha de Cita</label>
                    <input type="date" class="form-control" id="fcitab"/>
                </div>
                <div class="mt-2" style="display: flex; align-items: end">
                    <input type="submit" class="btn btn-primary" value="Buscar consultas" id="btnconsultar" />
                    <a href="../index.aspx" class="mx-2 btn btn-secondary">Volver</a>
                </div>
            </div>
        </div>
        <hr />
        <div class="row row-cols-1 row-cols-md-2" id="consultas">
        </div>
        </div>
    </div>

    <div class="modal fade" id="modalreservas" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <input type="hidden" id="idconsulta"/>
              <div id="mensaje"></div>
                 <div class="form-group">
                     <label>Paciente</label>
                     <input type="text" class="form-control" id="dni" placeholder="Buscar a paciente por DNI" autocomplete="off" />
                  </div>
                  <div id="resultado">
                
                  </div>
                  <div class="form-group">
                      <label>Fecha de Cita:</label>
                      <input type="date" class="form-control" id="fechacita"/>
                  </div>
                  <div class="form-group">
                      <label>Monto a Pagar:</label>
                      <input type="text" class="form-control"  id="precio" disabled/>
                  </div>
                  <div class="form-group">
                      <label>Monto entregado</label>
                      <input type="number" step="0.01" class="form-control" min="0" id="montoentregado"/>
                  </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary" id="guardar">Save changes</button>
              </div>
            </div>
          </div>
        </div>

    <script type="text/javascript">
        const horario = document.querySelector('#horario');
        const especialidad = document.querySelector("#especialidad");
        const contenedorConsulta = document.querySelector("#consultas");
        const fechacita = document.querySelector("#fechacita");
        const fcitab = document.querySelector("#fcitab");
        const resultadocontenedor = document.querySelector("#resultado");

        document.addEventListener('DOMContentLoaded', function () {
            getEspecialidades()
            getHorarios()
        })

        // Fecha minima
        const date = new Date();
        const day = date.getDate()+1 < 10 ? '0' + (date.getDate()+1) : date.getDate()+1;
        const month = (date.getMonth() + 1) < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth()+1);
        const year = date.getFullYear();

        fechacita.min = year + '-' + month + '-' + day;
        fcitab.min = year + '-' + month + '-' + day

        $(document).on('change', '#dni', function (e) {
            e.preventDefault();
            const data = { dni: e.target.value }

            searchPaciente(data)
        });

        $(document).on('click', '#reserva', function (e) {
            $("#idconsulta").val(e.target.dataset.id)
            $("#precio").val(e.target.dataset.precio)
        })

        $(document).on("click", "#guardar", function (e) {
            e.preventDefault();
            const montoentregado = document.querySelector("#montoentregado").value;
            const idconsulta = document.querySelector("#idconsulta").value;
            const fechacita = document.querySelector("#fechacita").value;
            const idpaciente = document.querySelector("#idpaciente").value;
            //
            const precio = document.querySelector("#precio").value;

            if (montoentregado == '' || fechacita == '' || idpaciente == '') {
                swal('Error!!!','Completar todos los campos','error')
                return;
            }

            if (parseFloat(montoentregado) < parseFloat(precio)) {
                swal('Error!!!','El monto entregado es menos al precio de la consulta','error')
                return;
            }            

            const data = {
                montoentregado: montoentregado,
                idconsulta: idconsulta,
                fechacita: fechacita,
                idpaciente: idpaciente,
                transaccion: Date.now()
            }

            guardar(data)
        })

        function guardar(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/reservasgeneral/index.aspx/saveReserva',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    if (e.d) {

                        $("#modalreservas").modal('hide');
                        swal('Exito!!!', 'Se guardo con éxito la reserva', 'success')
                    } else {
                        swal('Error!!!','Error al registrar','error')
                    }
                }
            })
        }

        function searchPaciente(data) {
            limpiarHtmlResp()
            $.ajax({
                type: 'POST',
                url: '/tecnico/citamedica/consultahorario.aspx/searchPaciente',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { idpacientes, nombre, apellido, dni } = e.d;
                    const div = document.createElement('div');
                    if (idpacientes != '') {
                        div.innerHTML = `
                        <input type="hidden" id="idpaciente" value="${idpacientes}" />
                       <label class="fw-bold">Paciente:</label>
                       <p class="text-capitalize">${apellido}, ${nombre}</p>
                       <label class="fw-bold">DNI:</label>
                       <p>N° ${dni}</p>
                        `;
                    } else {
                        div.innerHTML = ` 
                            <div class="alert alert-danger text-center mt-3">
                                No se encontro al paciente o no esta registrado    
                            </div>
                        `;
                    }
                    resultadocontenedor.appendChild(div);
                }
            })
        }

        $(document).on('click', '#btnconsultar', function (e) {
            e.preventDefault()
            const hor = document.querySelector('#horario').value;
            const esp = document.querySelector("#especialidad").value;
            const fcitab = document.querySelector("#fcitab").value;
           
            if (hor == '' || esp == '' || fcitab == '') {
                swal('error!!', 'Completar los campos para buscar las consultas', 'error');
                return;
            }
            fechacita.value = fcitab
            const data = { horarios: hor, especialidads: esp, fcitab };
            obtenerConsultar(data)
        })

        function obtenerConsultar(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/reservasgeneral/index.aspx/searchConsultaFiltro',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;
                    limpiarContenedor()
                    if (d.length > 0) {
                        d.forEach((cons) => {
                            const { idconsulta, medico, especialidad, horainicio, horafinal, precio, mensaje } = cons;
                            const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                            const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                            const div = document.createElement('div');
                            div.classList.add('col');
                                div.innerHTML = `
                                <div class="card mt-3">
                                    <div class="card-body">
                                      <h5 class="card-title text-capitalize">${especialidad}</h5>
                                        <p>Horario disponible: ${horai} : ${horaf}</p>
                                      <p class="card-text text-capitalize">Médico:<span class="fw-bold">${medico}</span> </p>
                                       <p class="card-text">Precio: <span class="fw-bold">S/.${precio}.00</span></p>
                                    </div>
                                    <div class="card-footer">
                                        <button
                                             type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalreservas"
                                            class="btn btn-success" data-id="${idconsulta}" data-precio="${precio}" id="reserva">Reservar Consulta</button>
                                    </div>
                                </div>
                            `;
                            

                            contenedorConsulta.appendChild(div)
                        })
                    } else {
                        const div = document.createElement('div')
                        div.classList.add('col');
                        div.innerHTML = `
                            <div class="alert alert-primary">
                                <p>Las consultas que estaban buscando no han sido asignadas o ya han sido reservados</p>
                            </div>
                        `;
                        contenedorConsulta.appendChild(div)
                    }
                }
            })
        }

        function getHorarios() {
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

        function getEspecialidades() {
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

        function limpiarContenedor() {
            while (contenedorConsulta.firstChild) {
                contenedorConsulta.removeChild(contenedorConsulta.firstChild);
            }
        }

        function limpiarHtmlResp() {
            while (resultadocontenedor.firstChild) {
                resultadocontenedor.removeChild(resultadocontenedor.firstChild)
            }
        }
    </script>
</asp:Content>
