<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.tecnico.index" %>
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
            <div class="column mt-3">
                <div class="col-sm">
                    <h1>Bienvenido: <span class="font-bold" style="text-transform: capitalize; font-weight: 400  ">
                    <asp:Label ID="lblSNombre" runat="server" ></asp:Label></span>
                    </h1>
                </div>
                <div class="col-sm">
                    <h3>Cargo: 
                     <span class="font-bold" style="text-transform: capitalize;">
                         <asp:Label ID="lblScargo" runat="server" ></asp:Label>
                     </span>
                    </h3>
                    <asp:Button ID="btnCerrar" runat="server" CssClass="btn btn-danger" Text="Cerrar Session" OnClick="btnCerrar_Click" />
                </div>
            </div>  
            
            <hr />
    
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <div class="col">
                    <div class="card">
                        <div class="card-body">
                          <h5 class="card-title">Pacientes</h5>
                          <p class="card-text">Se vera el listado de pacientes, y registro de la misma</p>
                        </div>
                        <div class="card-footer">
                            <a class="btn btn-success" href="/tecnico/pacientes/index">Ver pacientes</a>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card">
                        <div class="card-body">
                          <h5 class="card-title">Cita Medica</h5>
                          <p class="card-text">Se vera el listado de cita medica, y registro de la misma</p>
                        </div>
                        <div class="card-footer">
                            <a class="btn btn-success" href="/tecnico/citamedica/consultahorario">Ver Citas médica</a>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card">
                        <div class="card-body">
                          <h5 class="card-title">Reserva General - registro de citas</h5>
                          <p class="card-text"></p>
                        </div>
                        <div class="card-footer">
                            <a class="btn btn-success" href="/tecnico/reservasgeneral/index">Ver Citas médica</a>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card">
                        <div class="card-body">
                          <h5 class="card-title">Reserva General - Consultas por Fecha</h5>
                          <p class="card-text"></p>
                        </div>
                        <div class="card-footer">
                            <a class="btn btn-success" href="/tecnico/reservas/index">Realizar Consulta</a>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card">
                        <div class="card-body">
                          <h5 class="card-title">Realizar actualizacion de pago de reservas en linea</h5>
                          <p class="card-text"></p>
                        </div>
                        <div class="card-footer">
                            <a class="btn btn-success" href="/tecnico/pagos/index">Pago Reservas Online</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
