<%@ Page Title="" Language="C#" MasterPageFile="~/Pdf.Master" AutoEventWireup="true" CodeBehind="PDF.aspx.cs" Inherits="Clinica_DSII.paciente.citasmedicas.PDF" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.debug.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.2/html2canvas.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pdf">
        <div class="head-pdf">
            <img src="../../img/logo.png" alt="" class="img-pdf">
            <div class="titulo-head">
                <h1>Clinica Izaguirre</h1>
            </div>
            <div>
                <div class="dato-pdf">
                    <p>N° Transaccion: <span id="idtrasanc"></span></p>
                    <p>N° RUC <span>000222333444</span></p>
                    <p>Dirección: <span>av. san izaguirre 8505 urb. san elvira</span></p>
                    <p>Fecha de emisión: <span id="freserva">15/05/2022</span></p>
                </div>
            </div>
        </div>
        <div>
            <div class="datos-cliente">
                <div class="nom-dato">
                    <label>Apellidos y Nombres: </label>
                    <p class="text-capitalize" id="paciente"></p>
                </div>
                <div class="dni-dato">
                    <label>D.N.I. :</label>
                    <p id="dni"></p>
                </div>
            </div>
        </div>
        <div class="content-table">
            <table class="table mt-2">
                <thead class="table-dark table-striped">
                    <tr>
                        <th>N°</th>
                        <th>Descripción</th>
                        <th>Fecha de cita</th>
                        <th>Hora de cita</th>
                        <th>Precio</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td id="descripcion"></td>
                        <td id="fcita"></td>
                        <td id="horario"></td>
                        <td id="precio"></td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="4" class="text-right">Total :</td>
                        <td id="total"></td>
                    </tr>
                </tfoot>
            </table>
        </div>
        <div class="text-center">
            <p class="mensaje-footer">Muchas Gracias por su preferencia</p>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="script" runat="server">
    <script type="text/javascript">
        const descrip = document.querySelector("#descripcion");
        const fcitas = document.querySelector("#fcita");
        const horario = document.querySelector("#horario");
        const precios = document.querySelector("#precio");
        const total = document.querySelector("#total");
        const transac = document.querySelector("#idtrasanc");
        const femision = document.querySelector("#freserva")
        const pac = document.querySelector("#paciente");
        const dnis = document.querySelector("#dni")
        function generarPDF() {
            const quality = 1 // Higher the better but larger file
            html2canvas(document.querySelector("#html"),
                { scale: quality }
            ).then(canvas => {
                const pdf = new jsPDF('l', 'mm', [230, 600]);
                pdf.addImage(canvas.toDataURL('image/png'), 'PNG', 0, 0, 210, 100);
                pdf.save('dataurlnewwindow', { filename: 'fichero-pdf.pdf' });
                setTimeout(() => {
                    window.close()
                }, 500)
            });
        }

        obtenerData()

        function obtenerData() {
            const valores = window.location.search;

            const urlParams = new URLSearchParams(valores);

            var transaccion = urlParams.get('transaccion');

            const data = { transaccion: transaccion }
            console.log(data)
            $.ajax({
                type: 'POST',
                url: '/tecnico/citamedica/PDF.aspx/obtenerData',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (e) {
                    const { transaccion, medico, paciente, dni, especialidad, precio, estado, horainicio, horafinal, freserva, fcita } = e.d;
                    const emision = fechaConvert(freserva);
                    const cita = fechaConvert(fcita);
                    const horai = (horainicio.Hours < 10 ? '0' + horainicio.Hours : horainicio.Hours) + ':' + (horainicio.Minutes < 10 ? '0' + horainicio.Minutes : horainicio.Minutes);
                    const horaf = (horafinal.Hours < 10 ? '0' + horafinal.Hours : horafinal.Hours) + ':' + (horafinal.Minutes < 10 ? '0' + horafinal.Minutes : horafinal.Minutes);
                    descrip.innerHTML = `
                       <p>Consulta con el médico <span class="fw-bold text-capitalize">${medico}</span> en la especialidad de <span class="fw-bold text-capitalize">${especialidad}</span></p>
                    `;
                    precios.textContent = parseFloat(precio).toFixed(2);
                    total.textContent = parseFloat(precio).toFixed(2);
                    transac.textContent = transaccion;
                    dnis.textContent = dni;
                    pac.textContent = paciente;
                    fcitas.textContent = cita;
                    femision.textContent = emision;
                    horario.textContent = `${horai} - ${horaf}`

                    generarPDF();
                }
            })
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
