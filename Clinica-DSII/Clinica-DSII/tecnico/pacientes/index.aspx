<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.tecnico.pacientes.indexx" %>
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
            <h1>Pacientes</h1>
            <div class="mt-3">
                <a class="btn btn-secondary" href="/tecnico/index">Volver</a>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalsaldo">Recargar saldo</button>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalpaciente" id="clickmodal">
                  Crear Pacientes
                </button>
            </div>
    
            <hr />
    
            <div class="table-responsive mt-3">
                <table class="table" id="table-paciente">
                    <thead>
                        <tr>
                            <th>Pacientes</th>
                            <th>D.N.I.</th>
                            <th>Correo Electronico</th>
                            <th>Fecha de Nacimiento</th>
                            <th>Estado Civil</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- Modal Recarga -->
    <div class="modal fade" id="modalsaldo" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="">Modal title</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
             <div class="form-group">
                 <label>Buscar por DNI:</label>
                 <input type="text" class="form-control" id="dnir" />
             </div>
              <input type="submit" class="btn btn-success mt-2" id="buscar" />
              <div id="resultado">

              </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary" id="saver">Guardar</button>
          </div>
        </div>
      </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="modalpaciente" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
              <div id="respuesta"></div>
            <div class="row row-cols-1 row-cols-md-3">
                <input type="hidden" id="idpaciente" />
                <div class="col">
                    <label>Nombres:</label>
                    <input type="text" class="form-control" id="nombre" />
                </div>
                <div class="col">
                    <label>Apellidos:</label>
                    <input type="text" class="form-control" id="apellido"/>
                </div>
                <div class="col">
                    <label>D.N.I.:</label>
                    <input type="text" class="form-control" id="dni"/>
                </div>
            </div>
            <div class="row row-cols-1 row-cols-md-2 mt-3">
                <div class="col">
                    <label>Correo Electronico:</label>
                    <input type="email" class="form-control" id="correo"/>
                </div>
                <div class="col">
                    <label>Fecha Nacimiento:</label>
                    <input type="date" class="form-control" id="fechanac"/>
                </div>
            </div>
              <div class="row row-cols-1 row-cols-md-2 mt-3">
                  <div class="col">
                      <label>Estado Civil</label>
                      <select class="form-control" id="estcivil">
                          <option>--seleccione--</option>
                          <option value="soltero">SOLTERO</option>
                          <option value="casado">CASADO</option>
                          <option value="casado">VIUDO</option>
                          <option value="divrociado">DIVORCIADO</option>
                      </select>
                  </div>
                  <div class="col">
                      <label>Contraseña</label>
                      <input type="password" class="form-control" id="contrasenia"/>
                  </div>
              </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary" id="save">Guardar</button>
          </div>
        </div>
      </div>
    </div>
    <script type="text/javascript">
        const tablepaciente = document.querySelector("#table-paciente tbody");
        const respuesta = document.querySelector("#respuesta");
        const resultado = document.querySelector("#resultado");

        $(document).on('click', '#buscar', function (e) {
            e.preventDefault();
            const dni = $("#dnir").val();
            if (dni == '') {
                swal("Error!!!","Complete el campo para buscar paciente","error")
                return;
            }
            const data = { dni }

            $.ajax({
                type: 'POST',
                url: '/tecnico/pacientes/index.aspx/searchPaciente',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { idpacientes, paciente, dni, correo, saldo } = e.d;
                    if (idpacientes == 0) {
                        resultado.innerHTML = `
                            <div class="alert alert-primary">No se encontraron al paciente con el N° DNI <span class="fw-bold">${dni}</span></div>
                            `
                    } else {
                        resultado.innerHTML = `
                            <div class="form-group">
                                <label>Paciente</label>
                                <p>${paciente} - DNI: <span class="fw-bold">${dni}</span></p>
                                <label>Correo Electronico</label>
                                <p>${correo}</p>
                                <label>Saldo disponible</label>
                                <p class="bg-secondary bg-gradient p-2 rounded text-white m-0">${parseFloat(saldo).toFixed(2)}</p>
                            </div>
                            <div class="mt-2">
                                <input type="hidden" id="idpaciente" value="${idpacientes}" />
                                <label>Cantidad de saldo</label>
                                <input type="number" class="form-control" id="saldo" step="0.01" min="0"/>
                            </div>
                        `;
                    }
                }
            })
        })
        listar()

        $(document).on("click", "#saver", function (e) {
            e.preventDefault();
            const idpac = $("#idpaciente").val();
            const saldo = $("#saldo").val();
            const data = { idpac, saldo }

            if (saldo == '') {
                swal('error!!', 'Completar los campos correspondiente', 'error')
                return;
            }

            $.ajax({
                type: 'POST',
                url: '/tecnico/pacientes/index.aspx/recargaPaciente',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (c) {
                    const { d } = c;
                    if (d) {
                        $("#dnir").val("")
                        resultado.innerHTML = ``
                        $("#modalsaldo").modal("hide");
                        swal("Exito!!!","Su recarga se realizo con éxito","success")
                    }
                }
            })
        })

        $(document).on('click', '#clickmodal', function (e) {
            clear()
        })

        $(document).on('click', '#save', function (e) {
            e.preventDefault();

            const nombre = document.querySelector("#nombre").value.trim();
            const apellido = document.querySelector("#apellido").value.trim();
            const dni = document.querySelector("#dni").value.trim();
            const correo = document.querySelector("#correo").value.trim();
            const fechanacimiento = document.querySelector("#fechanac").value;
            const estadocivil = document.querySelector("#estcivil").value;
            const contrasenia = document.querySelector("#contrasenia").value.trim();
            const idpaciente = $("#idpaciente").val()

            const data = {
                nombre, apellido, dni, correo, fechanacimiento, estadocivil, contrasenia
            }

            if (nombre == "" || apellido == "" || dni == "" || correo == "" || fechanacimiento == "" || estadocivil == "" || contrasenia == "") {
                mostrarMensaje('Completar todos la campos','danger')
                return;
            }

            if (idpaciente == "") {
                save(data)
            } else {
                data.idpaciente = idpaciente;
                update(data)
            }
        })

        function listar() {
            $.ajax({
                type: 'POST',
                url: '/tecnico/pacientes/index.aspx/getPacientes',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    const { d } = e;
                    limpiarHtmlTable();
                    if (d.length > 0) {
                        d.forEach((pac) => {
                            const { idpacientes, nombre, apellido, dni, correo, fechanacimiento, estadocivil, contrasenia } = pac;
                            const fechanac = fechanacimiento.split('/');
                            const fecha1 = fechanac[1].split('Date');
                            const fecha2 = fecha1[1].split(')');
                            const fecha3 = fecha2[0].split('(');
                            const fechan = parseInt(fecha3[1]);
                            const fecha = new Date(fechan);
                            const fechanacimie = fecha.getDate() + '/' + (fecha.getMonth()+1) + '/' + fecha.getFullYear();
                            console.log(fechanacimie)
                            
                            const tr = document.createElement('tr');
                            tr.innerHTML = `
                                <td>${apellido}, ${nombre}</td>
                                <td>${dni}</td>
                                <td>${correo}</td>
                                <td>${fechanacimie}</td>
                                <td>${estadocivil}</td>
                                <td>
                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalpaciente" id="editar" data-id="${idpacientes}">Editar</button>
                                    <button type="button" class="btn btn-danger" data-id="${idpacientes}" id="eliminar">X</button>
                                </td>
                            `;
                            tablepaciente.appendChild(tr)
                        })
                        
                    } else {
                        const tr = document.createElement('tr');
                        tr.innerHTML = `
                            <td>No hay registro de los pacientes</td>
                        `;
                        tablepaciente.appendChild(tr);
                    }
                }
            })
        }

        $(document).on('click', '#editar', function (e) {
            const data = {
                idpaciente: e.target.dataset.id
            }
            getPaciente(data)
        })

        function getPaciente(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/pacientes/index.aspx/getPaciente',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { idpacientes, nombre, apellido, dni, correo, fechanacimiento, estadocivil, contrasenia } = e.d;
                    const fechanac = fechanacimiento.split('/');
                    const fecha1 = fechanac[1].split('Date');
                    const fecha2 = fecha1[1].split(')');
                    const fecha3 = fecha2[0].split('(');
                    const fechan = parseInt(fecha3[1]);
                    const fecha = new Date(fechan);
                    const mes = (fecha.getMonth() + 1) < 10 ? '0' + (fecha.getMonth() + 1) : (fecha.getMonth() + 1)
                    const dia = fecha.getDate() < 10 ? '0' + (fecha.getDate()) : fecha.getDate();
                    const fechanacimie = fecha.getFullYear() + '-' + mes + '-' + dia;
                    console.log(fechanacimie)
                    $("#nombre").val(nombre)
                    $("#apellido").val(apellido)
                    $("#dni").val(dni)
                    $("#correo").val(correo)
                    $("#fechanac").val(fechanacimie)
                    $("#estcivil").val(estadocivil)
                    $("#contrasenia").val(contrasenia)
                    $("#idpaciente").val(idpacientes)
                }
            })
        }

        $(document).on('click', '#eliminar', function (e) {
            const data = {
                idpaciente: e.target.dataset.id
            }

            swal({
                title: "¿Seguro que quieres eliminar este paciente",
                text: "Una vez eliminado, ya no se podra recuperar los datos",
                icon: "warning",
                buttons: true,
                dangerMode: true,
            })
                .then((resp) => {
                    if (resp) {
                        eliminar(data)
                    } else {
                    }
                });
        })

        function clear() {
            $("#nombre").val('')
            $("#apellido").val('')
            $("#dni").val('')
            $("#correo").val('')
            $("#fechanac").val('')
            $("#estcivil").val('')
            $("#contrasenia").val('')
            $("#idpaciente").val('')
        }

        function save(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/pacientes/index.aspx/save',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e; 
                    if (d) {
                        $("#modalpaciente").modal('hide')
                        listar()
                        swal('Exito!!!', 'Se guardo correctamente los datos del paciente', 'success')
                    } else {
                        swal("Error!!!","Correo Electronico o DNI ya se encuentran registrado","error")
                    }
                }
            })
        }

        function update(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/pacientes/index.aspx/update',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;
                    if (d) {
                        $("#modalpaciente").modal('hide')
                        listar()
                        swal('Exito!!!', 'Se actualizaron correctamente los datos del paciente', 'success')
                    } else {
                        swal("Error!!!", "Hubo error durante la actualizacion del paciente", "error")
                    }
                }
            })
        }

        function eliminar(data) {
            $.ajax({
                type: 'POST',
                url: '/tecnico/pacientes/index.aspx/delete',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;

                    if (d) {
                        swal('Exito!!!', 'Se elimino con exito el paciente', 'success')
                        listar();
                    } else {
                        swal('Error!!!', 'Error al eliminar el paciente, puede que ya este vinculado con otros servicios', 'error')
                    }
                }
            })
        }

        function mostrarMensaje(mensaje, tipo) {
            limpiarHtmlMensaje()
            const div = document.createElement('div');
            div.classList.add('alert', `alert-${tipo}`, 'text-center', 'mt-3');
            div.innerHTML = `
                ${mensaje}
            `;
            respuesta.appendChild(div);
            
        }

        function limpiarHtmlTable() {
            while (tablepaciente.firstChild) {
                tablepaciente.removeChild(tablepaciente.firstChild);
            }
        }

        function limpiarHtmlMensaje() {
            while (respuesta.firstChild) {
                respuesta.removeChild(respuesta.firstChild);
            }
        }
    </script>
</asp:Content>
