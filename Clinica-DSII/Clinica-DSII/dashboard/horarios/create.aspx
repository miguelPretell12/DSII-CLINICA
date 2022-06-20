<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="create.aspx.cs" Inherits="Clinica_DSII.dashboard.horarios.creates" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <div class="dashboard">
        <div class="panel">
            <div class="cabecera">
                <h1>Clinica Izaguirre</h1>
            </div>
            <ul class="lista-servicio">
                <li><a href="/dashboard/usuarios/index">Usuarios</a></li>
                <li><a href="/dashboard/horarios/create">Horarios</a></li>
                <li><a href="/dashboard/especialidadMedico/index">Especialidad-Medico</a></li>
                <li><a href="/dashboard/consultas/index">Consultas</a></li>
            </ul>
        </div>
        <div class="contenido container"> 
            <h1>Horarios</h1>
            
        <div class="row">
            <input type="hidden" id="horario"/>
            <div class="col-sm">
                <asp:Label ID="Label1" runat="server" Text="Hora Inicio"></asp:Label>
                <asp:TextBox ID="txtHoraI" runat="server" TextMode="Time" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtHoraI" ErrorMessage="RequiredFieldValidator" ForeColor="Red">*Campo Requerido</asp:RequiredFieldValidator>
            </div>
            <div class="col-sm">
                <asp:Label ID="Label2" runat="server" Text="Hora Final"></asp:Label>
                <asp:TextBox ID="txtHoraF" runat="server" TextMode="Time" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtHoraF" ErrorMessage="RequiredFieldValidator" ForeColor="Red">*Campo Requerido</asp:RequiredFieldValidator>
            </div>
        </div>
         <asp:Label ID="lblr" runat="server" ></asp:Label>
        <div class="mt-3">
            <a runat="server" href="~/dashboard/admin.aspx" class="btn btn-outline-danger">Dashboard</a>
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" />
            <!-- <button id="guardar" class="btn btn-primary">Guardar</button> -->
            <button type="button" id="restaurar" class="btn btn-secondary" >Restaurar</button>
        </div>
        <div class="table-responsive mt-3">
            <table id="tblhorario" class="table">
                <thead>
                    <tr>
                        <th>Hora Inicio</th>
                        <th>Hora Final</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        </div>
    </div>

    <script type="text/javascript">

        const tblhorario = document.querySelector('#tblhorario tbody');
        console.log(tblhorario)
        const btnGuardar = document.querySelector("#<%= btnGuardar.ClientID %>");

        function listar() {
            $("#spinner").show()
            $.ajax({
                type: 'POST',
                url: '/dashboard/horarios/create.aspx/listar',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (e) {
                    if (e) {
                        $("#spinner").hide()
                    }
                    limpiarHtmlTabla();
                    const { d } = e;
                    d.forEach((hora) => {
                        const { idhorario, horainicio, horafinal } = hora;
                        const tr = document.createElement('tr');
                        tr.innerHTML = `
                            <td>${horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours }:${horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes}</td>
                            <td>${horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours }:${horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes}</td>
                            <td>
                                <button type="button" class="btn btn-secondary" id="edit" data-id="${idhorario}">Editar</button>
                                <button type="button" class="btn btn-danger" id="delete" data-id="${idhorario}">Eliminar</button>
                            </td>
                        `;
                        tblhorario.appendChild(tr);
                    });
                }
            })
        }

        listar();

        $(document).on('click', '#edit', function (e) {
            const id = e.target.dataset.id;
            const data = { id: id }
            $("#spinner").show()
            $.ajax({
                type: 'POST',
                url: '/dashboard/horarios/create.aspx/obtenerHorario',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    if (e) {
                        $("#spinner").hide()
                    }
                    const { idhorario, horainicio, horafinal } = e.d;
                    //btnGuardar.innerHTML = "Actualizar";
                    btnGuardar.value= "Actualizar"
                    const inicioHour = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                    const finalHour = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes)
                    $("#<%= txtHoraI.ClientID %>").val(inicioHour);
                    $("#<%= txtHoraF.ClientID %>").val(finalHour);
                    $("#horario").val(idhorario)
                }
            })
        })

        $(document).on('click', "#restaurar", function (e) {
            $("#<%= txtHoraI.ClientID %>").val('');
            $("#<%= txtHoraF.ClientID %>").val('');
            $("#horario").val('')
            btnGuardar.value="Guardar"
        })

        $(document).on('click', '#<%= btnGuardar.ClientID %>', function (e) {
            e.preventDefault();
            const horaI = $("#<%= txtHoraI.ClientID %>").val();
            const horaF = $("#<%=  txtHoraF.ClientID %>").val();
            const idhorario = $("#horario").val();

            if (horaI == '' || horaF == '') {
                return;
            }

            const data = {
                horainicio:horaI,
                horafinal:horaF
            }

            if (idhorario == "") {
                filtro(data);
            } else {
                data.idhorario = idhorario;
                actualizar(data)
            }
        })

        $(document).on('click', "#delete", function (e) {
            const id = e.target.dataset.id;
            const data = {
                idhorario: id
            }
            swal({
                title: "¿Seguro que quieres eliminar este horario?",
                text: "Una vez eliminado, ya no se podra recuperar los datos",
                icon: "warning",
                buttons: true,
                dangerMode: true,
            })
                .then((resp) => {
                    if (resp) {
                        $.ajax({
                            type: 'POST',
                            url: '/dashboard/horarios/create.aspx/eliminar',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            data: JSON.stringify(data),
                            success: function (e) {
                                const { d } = e;
                                if (d) {
                                    swal('Exito!!', 'Se elimino con exito', 'success')
                                    listar();
                                } else {
                                    swal('Error!!','Error al eliminar', 'error')
                                }
                            }
                        })
                    } else {
                    }
                })
        })

        function limpiarHtmlTabla() {
            while (tblhorario.firstChild) {
                tblhorario.removeChild(tblhorario.firstChild)
            }
        }

        function filtro(data) {
            $.ajax({
                type: 'POST',
                url: '/dashboard/horarios/create.aspx/filtroExist',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e
                    if (d == 0) {
                        guardar(data)
                        listar();
                        limpiar()
                    } else {
                        swal('Error!!', 'Ya existe la hora de inicio o final en el registro', 'error')
                    }
                }
            })
        }

        function guardar(data) {
            $("#spinner").show()
            $.ajax({
                type: 'POST',
                url: '/dashboard/horarios/create.aspx/guardar',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    if (e) {
                        $("#spinner").hide()
                    }
                    const { d } = e;
                    if (d) {
                        swal('Exito!!', 'Registro Guardado', 'success');
                        listar()
                        limpiar()
                    } else {
                        swal('Error!!', '', 'success');
                    }
                }
            })
        }

        function actualizar(data) {
            $.ajax({
                type: 'POST',
                url: '/dashboard/horarios/create.aspx/actualizar',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { d } = e;

                    if (d) {
                        swal('Exito!!', 'Datos actualizados con exito', 'success');
                        listar()
                        limpiar()
                    } else {
                        swal('Error!!', '', 'success');
                    }
                }
            })
        }

        function limpiar() {
            $("#<%= txtHoraI.ClientID %>").val('');
            $("#<%= txtHoraF.ClientID %>").val('');
            $("#horario").val('')
            btnGuardar.value = "Guardar"
        }


    </script>
</asp:Content>
