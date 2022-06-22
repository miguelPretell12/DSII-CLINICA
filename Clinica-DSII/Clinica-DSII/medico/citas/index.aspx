<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.medico.citamedica.index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
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
        <div class="contenido container" style="overflow-y: scroll"> 
            <h1>Consultar Cita</h1>
        <div class="row row-cols-1 row-cols-md-3">
            <div class="col">
                <div class="my-3">
                    <label>N° Transaccion o N° DNI</label>
                    <input type="text" class="form-control" id="trandni"/>
                </div>
                <a class="btn btn-secondary" href="../index.aspx">Volver</a>
                <input type="submit" class="btn btn-success" id="buscar" value="Buscar Cita" />
            </div>
            <div class="col">

            </div>
        </div>
        <div class="mt-3" id="resultado">

        </div>
        </div>
    </div>
    <script type="text/javascript">
        const resultado = document.querySelector("#resultado");
        
        $(document).on("click", "#buscar", function (e) {
            e.preventDefault();
            const trandni = document.querySelector("#trandni").value
            if (trandni == '') {
                swal('Error!!', 'Completar los campos correspondiente', 'error')
                return;
            }

            const data = { trandni }
            buscarReserva(data)
        });

        function buscarReserva(data) {
            $.ajax({
                type: 'POST',
                url: '/medico/citas/index.aspx/buscar',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { idreserva, medico, paciente, dni, estado, especialidad, transaccion } = e.d
                    const div = document.createElement("div");
                    const status = estado == null ? '' : estado.toLowerCase();
                    limpiarResultado();
                    if (status == 'concluido') {
                        div.innerHTML = `
                        <div class="">
                            <hr />
                                <h3>Datos de la reserva de la cita</h3>
                            <hr />
                            <input type="hidden" id="idreserva" value="${idreserva}" />
                              <div>
                                  <label>N° Transaccion de la cita:</label>
                                  <p>${transaccion}</p>
                              </div>
                              <div>
                                  <label>Paciente:</label>
                                  <p>${paciente}</p>
                              </div>
                              <div>
                                  <label>N° D.N.I. :</label>
                                  <p>${dni}</p>
                              </div>
                              <div>
                                  <label>Médico a cargo </label>
                                  <p>${medico} - ${especialidad}</p>
                              </div>
                        </div>
                        <hr />
                        <h3>Ficha Medica</h3>
                        <hr />
                        <div class="row row-cols-1 row-cols-md-3 ">
                            <div class="form-group my-3">
                                <label>¿ Eres alérgico a algun medicamente?</label>
                                <select id="alergia" class="form-control">
                                    <option disable>--seleccione--</option>
                                    <option value="si" >Si</option>
                                    <option value="no" >No</option>
                                </select>
                            </div>
                            <div class="form-group my-3">
                                <label>Peso</label>
                                <input type="number" class="form-control" min="0" max="400" step="0.01" id="peso" />
                            </div>

                            <div class="form-group my-3">
                                <label>Estatura</label>
                                <input type="number" class="form-control" min="0" max="5" step="0.01" id="estatura" />
                            </div>
                        </div>
                        <hr />
                        <h3>Observacion de la cita</h3>
                        <hr />
                        <div class="row row-cols-1 row-cols-md-2 my-3">
                            <div class="form-group my-3">
                                <label>Descripcion de la cita</label>
                                <textarea class="form-control" style="height:180px" id="observacion"></textarea>
                            </div>
                            <div class="form-group my-3">
                                <label>Receta médica</label>
                                <textarea class="form-control" style="height:180px" id="receta"></textarea>
                            </div>
                        </div>
                        <input type="submit" id="guardar" value="GUARDAR" class="btn btn-success" />
                    `;
                    } else {
                        div.innerHTML = `
                           <div class="alert alert-danger text-center">
                                <p class="m-0">La reserva no ha sido pagada o no se ha reservado</p>
                           </div>
                        `;
                    }

                    resultado.appendChild(div)
                }
            })
        }

        $(document).on('click', '#guardar', function (e) {
            e.preventDefault();
            const idreserva = document.querySelector("#idreserva").value;
            const alergia = document.querySelector("#alergia").value;
            const peso = document.querySelector("#peso").value;
            const estatura = document.querySelector("#estatura").value;
            const observacion = document.querySelector("#observacion").value;
            const receta = document.querySelector("#receta").value;

            if (idreserva == '' || observacion == '' || peso == '' || alergia == '' || estatura == '' || receta == '') {
                swal('Error!!!', 'Completar todos los campos', 'error');
                return;
            }

            const data = {
                idreserva,
                alergia,
                peso,
                estatura,
                observacion,
                receta
            }
            saveFicha(data)
        })

        function saveFicha(data) {
            $.ajax({
                type: 'POST',
                url: '/medico/citas/index.aspx/save',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    if (e) {
                        limpiarResultado();
                        swal('Exito!!!','Se guardo los datos de la cita establecida','success')
                    } else {
                        swal("Error!!!", "Hubo un error al guardar", 'error')
                    }
                }
            })
        }

        function limpiarResultado() {
            while (resultado.firstChild) {
                resultado.removeChild(resultado.firstChild);
            }
        }
    </script>
</asp:Content>
