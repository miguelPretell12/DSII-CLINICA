<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="consultahorario.aspx.cs" Inherits="Clinica_DSII.tecnico.citamedica.consultahorario" %>

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
            <h3>Consultar horarios para la reserva de citas para el dia de <span id="fecha"></span></h3>
            <div class="row row-cols-1 row-cols-md-2">
                <div class="col">
                    <label>Buscar por Horario</label>
                    <select class="form-control w-50" id="horario">
                        <option>--seleccione--</option>
                    </select>
                    <a class="btn btn-secondary mt-3" href="/tecnico/index">Volver</a>
                    <input type="submit" class="btn btn-success mt-3" value="Buscar" id="buscar" />
                    <button type="button" class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#verreservas" id="mostrar">Ver reservas</button>
                </div>
                <div class="col">
                </div>
            </div>
            <hr />
            <div class="row row-cols-1 row-cols-md-2" id="contenedorConsultas">

            </div>
        </div>
    </div>

    <div class="modal fade" id="verreservas" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="">Modal title</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
              <div class="form-group">
                  <label>Buscar por N° de Transicion</label>
                  <input type="text" class="form-control w-50" id="btransaccion">
              </div>
            <div class="table-responsive mt-3">
                <table class="table w-100" id="tblreservas">
                    <thead class="table-dark">
                        <tr>
                            <th>ID Transacción</th>
                            <th>Especialidad</th>
                            <th>Medico</th>
                            <th>Paciente</th>
                            <th>Precio</th>
                            <th>Fecha de Reserva</th>
                            <th>Fecha de Cita</th>
                            <th>Estado</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
          </div>
          <div class="modal-footer">
          </div>
        </div>
      </div>
    </div>

    <div class="modal fade" id="modalreservar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Crear Reserva</h5>
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
                  <input type="date" class="form-control" id="fechacita" disabled/>
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
            <button type="button" class="btn btn-primary" id="guardar">Save changes</button>
          </div>
        </div>
      </div>
    </div>

    
    
    <script type="text/javascript">
        const selecthorario = document.querySelector("#horario");
        const contenedorCons = document.querySelector("#contenedorConsultas");
        const fecha = document.querySelector("#fecha");
        const resultadocontenedor = document.querySelector("#resultado");
        const contenedorMensaje = document.querySelector("#mensaje");

        const contenedortblreserva = document.querySelector("#tblreservas tbody");

        const pdfbody = document.querySelector("#body-pdf");

        const date = new Date()
        const day = date.getDate();
        const month = date.getMonth() + 1;
        const year = date.getFullYear();
        fecha.textContent = day + '/' + month + '/' + year;

        function fechaCita() {
            const citafec = document.querySelector("#fechacita");
            const dia = day < 10 ? '0' + day : day;
            const mes = month < 10 ? '0' + month : month;
            citafec.value = year +'-'+ mes + '-' +dia ;
        }

        fechaCita()

        $(document).on('change', '#dni', function (e) {
            const data = { dni: e.target.value }
            searchPaciente(data)
        })

        $(document).on('click', '#buscar', function (e) {
            e.preventDefault();
            const idhorario = $("#horario").val();
            const data = { idhorario: idhorario }
            searchConsulta(data)
        })

        document.addEventListener('DOMContentLoaded', function (e) {
            getHorarios();
        })

        function getHorarios() {
            $.ajax({
                type: 'POST',
                url: '/tecnico/citamedica/consultahorario.aspx/getHorarios',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    const { d } = e
                    d.forEach((hor) => {
                        const { idhorario, horainicio, horafinal } = hor;
                        const option = document.createElement('option');

                        const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                        const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                        option.value = idhorario;

                        option.innerHTML = ` ${horai} - ${horaf} `;
                        selecthorario.appendChild(option);
                    })
                }
            })
        }

        function searchConsulta(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/citamedica/consultahorario.aspx/obtenerConsultaDisponible',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;
                    limpiarConsulta();
                    if (d.length > 0) {
                        d.forEach((dis) => {
                            const { idconsulta, medico, especialidad, horainicio, horafinal, precio } = dis;
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
                                             type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalreservar"
                                            class="btn btn-success" data-id="${idconsulta}" data-precio="${precio}" id="reserva">Reservar Consulta</button>
                                    </div>
                                </div>
                            `;

                            contenedorCons.appendChild(div)
                        })
                    } else {
                        const div = document.createElement('div');
                        const date = new Date()
                        const day = date.getDate();
                        const month = date.getMonth() + 1;
                        const year = date.getFullYear();
                        div.classList.add('col');
                        div.innerHTML = `
                                <div class="alert alert-primary mt-3">
                                    <p>No se encontraron consulta para la fecha de ${day}/${month}/${year}, por que posiblemente ya estén ocupadas</p>
                                </div>
                            `;

                        contenedorCons.appendChild(div)                    }
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
                    div.innerHTML = `
                        <input type="hidden" id="idpaciente" value="${idpacientes}" />
                       <label class="fw-bold">Paciente:</label>
                       <p class="text-capitalize">${apellido}, ${nombre}</p>
                       <label class="fw-bold">DNI:</label>
                       <p>N° ${dni}</p>
                        `;
                    resultadocontenedor.appendChild(div);
                }
            })
        }

        $(document).on('click', '#reserva', function (e) {
            const idconsulta = e.target.dataset.id;
            const precio = e.target.dataset.precio;
            $("#idconsulta").val(idconsulta);
            $("#precio").val(precio)
        })

        function limpiarConsulta() {
            while (contenedorCons.firstChild) {
                contenedorCons.removeChild(contenedorCons.firstChild);
            }
        }

        function limpiarHtmlResp() {
            while (resultadocontenedor.firstChild) {
                resultadocontenedor.removeChild(resultadocontenedor.firstChild)
            }
        }

        $(document).on('click', '#guardar', function (e) {
            e.preventDefault();
            const precio = $("#precio").val();
            const idconsulta = $("#idconsulta").val();
            const idpaciente = $("#idpaciente").val();
            const fechacita = $("#fechacita").val();
            const montoentre = $("#montoentregado").val();

            if (idpaciente == '' || montoentre == '' || fechacita == '' || idconsulta == '') {
                mostrarMensaje('Completar todos los campos', 'danger')
                return;
            }

            if (parseFloat(montoentre) < parseFloat(precio)) {
                mostrarMensaje('El monto entregado debe ser mayor que el monto asignado de la consulta','danger');
                return;
            }
            const data = {
                idpaciente: idpaciente,
                idconsulta: idconsulta,
                fechacita: fechacita,
                montoentregado: montoentre,
                idtransicion: Date.now()
            };

            guardar(data)
        })

        function guardar(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/citamedica/consultahorario.aspx/save',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;

                    if (d) {
                        limpiar()
                        $("#modalreservar").modal('hide');
                        listarReserva();
                        swal("Exito!!!", "Se reservo correctamente la cita ", "success")
                    } else {
                        swal("Error!!!","Hubo un error en la reservacion de la cita","error")
                    }
                }
            })
        }
        
        function listarReserva() {
            $.ajax({
                type: 'POST',
                url: '/tecnico/citamedica/consultahorario.aspx/listaReservasTransicion',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    const { d } = e;
                    limpiarReservas()
                    d.forEach((rsr) => {
                        const { idtransicion, especialidad, medico, paciente, precio, fcita, freserva, estado } = rsr;
                        const tr = document.createElement('tr');
                        const fechreserva = fechaConvert(freserva);
                        const fechcita = fechaConvert(fcita);
                        console.log(parseFloat(precio))
                        tr.innerHTML = `
                            <td>${idtransicion == '' ? 'No pagado' : idtransicion}</td>
                            <td>${especialidad}</td>
                            <td>${medico}</td>
                            <td>${paciente}</td>
                            <td>${parseFloat(precio).toFixed(2)}</td>
                            <td>${fechreserva}</td>
                            <td>${fechcita}</td>
                            <td>
                                <span class="badge bg-${estado.toLowerCase() == 'concluido'? 'success':'warning text-dark'}" >${estado}</span>
                            </td>
                            <td>
                                <button type="button" class="btn btn-danger" data-transaccion="${idtransicion}" id="pdfbtn" ${estado.toLowerCase() == 'concluido' ? '' :'disabled'}>PDF</button>
                            </td>
                        `
                        contenedortblreserva.appendChild(tr);
                    })
                }
            })
        }

        $(document).on("click", "#pdfbtn", function (e) {
            e.preventDefault();
            const data = { transaccion: e.target.dataset.transaccion }
            
            window.open(`/tecnico/citamedica/PDF.aspx?transaccion=${data.transaccion}`);
        })

        function listarReservaTransaccion(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/citamedica/consultahorario.aspx/listarbuscartransicion',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;
                    limpiarReservas();
                    d.forEach((rsr) => {
                        const { idtransicion, especialidad, medico, paciente, precio, fcita, freserva, estado } = rsr;
                        const tr = document.createElement('tr');
                        const fechreserva = fechaConvert(freserva);
                        const fechcita = fechaConvert(fcita);
                        tr.innerHTML = `
                            <td>${idtransicion == '' ? 'No pagado' : idtransicion}</td>
                            <td>${especialidad}</td>
                            <td>${medico}</td>
                            <td>${paciente}</td>
                            <td>${precio}</td>
                            <td>${fechreserva}</td>
                            <td>${fechcita}</td>
                            <td>
                                <span class="badge bg-${estado.toLowerCase() == 'concluido' ? 'success' : 'warning text-dark'}" >${estado}</span>
                            </td>
                        `
                        contenedortblreserva.appendChild(tr);
                    })
                }
            })
        }

        $(document).on("keyup", "#btransaccion", function (e) {
            const transaccion = e.target.value;

            if (transaccion == '') {
                listarReserva()
            } else {
                const data = { idtransicion: transaccion }
                listarReservaTransaccion(data);
            }
        })

        listarReserva()

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

        function limpiar() {
            $("#precio").val('');
            limpiarConsulta()
            $("#montoentregado").val('');
        }

        function limpiarReservas() {
            while (contenedortblreserva.firstChild) {
                contenedortblreserva.removeChild(contenedortblreserva.firstChild);
            }
        }

        function mostrarMensaje(mensaje, tipo) {
            limpiarMensaje();
            const div = document.createElement('div');
            div.classList.add('alert', `alert-${tipo}`, 'text-center');
            div.innerHTML = `
            ${mensaje}
            `;
            contenedorMensaje.appendChild(div);
        }

        function limpiarMensaje() {
            while (contenedorMensaje.firstChild) {
                contenedorMensaje.removeChild(contenedorMensaje.firstChild)
            }
        }
    </script>


</asp:Content>


