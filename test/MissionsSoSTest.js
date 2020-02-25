const MissionsSoS = artifacts.require('MissionsSoS');

let instancia;

beforeEach(async () => {
    instancia = await MissionsSoS.new();
});

contract('MissionsSoS', accounts => {

    it('Crear misiones', async() =>{
        await instancia.setMission("Mission 0001","#Mission0001",0);
        await instancia.setMission("Mission 0002","#Mission0002",0);
        await instancia.setMission("Mission 0001.0001","#Mission0001.0001",1);
        await instancia.setMission("Mission 0002.0001","#Mission0002.0001",2);
        
        assert.equal((await instancia.getMission(3))[4], 1, "El padre de la tercera misión no coincide");
        assert.equal(await instancia.totalMission(), 4, "Misiones no coinciden con el total de misiones");
    });

    /*
    it('Debe existir vuelos disponibles', async() =>{
        let total = await instancia.totalVuelos();
        assert (total > 0);
    });

    it('Debe permitir a los clientes comprar un vuelo, si el valor es el adecuado', async() =>{
        let vuelo = await instancia.vueloList(0);
        let nombreVuelo = vuelo[0], precioVuelo = vuelo[1];
        await instancia.comprarVuelo(0,{from: accounts[0], value:precioVuelo});
        let vueloCompradoMap = await instancia.vueloCompradoMap(accounts[0],0);
        let totalVueloCompradoPorClienteMap = await instancia.totalVueloCompradoPorClienteMap(accounts[0]);
        assert (vueloCompradoMap[0], nombreVuelo);
        assert (vueloCompradoMap[1], precioVuelo);
        assert (totalVueloCompradoPorClienteMap, 1);        
    });

    it('No debe permitir a los clientes comprar un vuelo, si el valor es menor al precio', async() =>{
        let vuelo = await instancia.vueloList(0);
        precioVuelo = vuelo[1]-1000;
        try{
            await instancia.comprarVuelo(0,{from: accounts[0], value:precioVuelo});
        }
        catch(e) {return;}
        assert.fail();
    });

    it('Debe tener el valor real del contrato', async() =>{
        let vuelo1 = await instancia.vueloList(0);
        let precioVuelo1 = vuelo1[1];

        let vuelo2 = await instancia.vueloList(1);
        let precioVuelo2 = vuelo2[1];

        await instancia.comprarVuelo(0,{from: accounts[0], value:precioVuelo1});
        await instancia.comprarVuelo(1,{from: accounts[0], value:precioVuelo2});
        
        let nuevoBalance = await instancia.getBalanceAerolinea();
        
        assert.equal(nuevoBalance.toNumber(),(precioVuelo1.toNumber()+precioVuelo2.toNumber()));

    });

    it('Debe permitir a los clientes canjear los puntos', async() =>{
        let vuelo = await instancia.vueloList(0);
        let precioVuelo = vuelo[1];

        await instancia.comprarVuelo(0,{from: accounts[0], value:precioVuelo});
                
        let balance = await web3.eth.getBalance(accounts[0]);
        await instancia.redimirPuntos({from: accounts[0]});
        let balanceFinal = await web3.eth.getBalance(accounts[0]);        
        
        let cliente = await instancia.clienteMap(accounts[0]);
        let puntos = cliente[0];

        assert(puntos, 0);
        assert(balanceFinal > balance);
    });
*/
    
    
});