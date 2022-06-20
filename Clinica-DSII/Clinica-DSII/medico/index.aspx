<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Clinica_DSII.medico.index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="">
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
                    <asp:Button ID="btnCerrrar" CssClass="btn btn-danger" runat="server" Text="Cerrar Sesion" OnClick="btnCerrrar_Click" />
                </div>
            </div> 
            <hr />
    
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <div class="col">
                    <div class="card">
                        <div class="card-body">
                          <h5 class="card-title">Citas Medicas</h5>
                          <p class="card-text">Se vera el listado de citas programadas y pagadas</p>
                        </div>
                        <div class="card-footer">
                            <a class="btn btn-success" href="/medico/citas/index">Ver citas</a>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card">
                        <div class="card-body">
                          <h5 class="card-title">Historial Médicos - Pacientes</h5>
                          <p class="card-text">Se vera el listado de horarios de los doctores, y registro de la misma</p>
                        </div>
                        <div class="card-footer">
                            <a class="btn btn-success" href="/medico/historial/index">Ver Historial Medico</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</asp:Content>
