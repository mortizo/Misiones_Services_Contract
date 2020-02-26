const MissionsSoSService = artifacts.require('MissionsSoSService');

let instancia;

beforeEach(async () => {
    instancia = await MissionsSoSService.new()
    await instancia.setMission("Mission 0001","#Mission0001",0)
    await instancia.setMission("Mission 0002","#Mission0002",0)
    await instancia.setMission("Mission 0001.0001","#Mission0001.0001",0)
    await instancia.setConstituent()
    await instancia.setConstituent()
    await instancia.setConstituent()
});

contract('MissionsSoS', accounts => {

    
    it('Crear misiones con los datos adecuados en las posiciones adecuadas', async() =>{       
        assert.equal((await instancia.getMission(2))[4], 0, "El padre de la tercera misión no coincide")
    });
    
    it('Crear misiones e ir actualizando el total de las misiones', async() =>{       
        assert.equal(await instancia.totalMission(), 3, "Misiones no coinciden con el total de misiones")
    });
    
    it('Crear constituyentes con los datos adecuados en las posiciones adecuadas', async() =>{       
        assert.equal((await instancia.getConstituent(2))[0], 2, "El código del tercer constituyente no coincide")
    });
    
    it('Crear constituyentes e ir actualizando el total de los constituyentes', async() =>{      
        assert.equal(await instancia.totalConstituent(), 3, "Constituyentes no coinciden con el total de constituyentes")
    });

    
    it('Crear parámetros en los constituyentes e ir actualizando el total de los parámetros por constituyente', async() =>{       
        await instancia.setConstituentParameter(0, "clave 1.1", "valor 1.1", "descripción 1.1" )
        await instancia.setConstituentParameter(1, "clave 2.1", "valor 2.1", "descripción 2.1" )
        await instancia.setConstituentParameter(1, "clave 2.2", "valor 2.2", "descripción 2.2" )
        await instancia.setConstituentParameter(2, "clave 3.1", "valor 3.1", "descripción 3.1" )
        await instancia.setConstituentParameter(2, "clave 3.2", "valor 3.2", "descripción 3.2" )
        await instancia.setConstituentParameter(2, "clave 3.3", "valor 3.3", "descripción 3.3" )  
        assert.equal(await instancia.totalConstituentParameter(0), 1, "Total de parámetros del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentParameter(1), 2, "Total de parámetros del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentParameter(2), 3, "Total de parámetros del constituyente no coinciden")
    });

    it('Crear parámetros en los constituyentes con los datos adecuados en las posiciones adecuadas', async() =>{       
        await instancia.setConstituentParameter(0, "clave 1.1", "valor 1.1", "descripción 1.1" )
        await instancia.setConstituentParameter(1, "clave 2.1", "valor 2.1", "descripción 2.1" )
        await instancia.setConstituentParameter(1, "clave 2.2", "valor 2.2", "descripción 2.2" )
        await instancia.setConstituentParameter(2, "clave 3.1", "valor 3.1", "descripción 3.1" )
        await instancia.setConstituentParameter(2, "clave 3.2", "valor 3.2", "descripción 3.2" )
        await instancia.setConstituentParameter(2, "clave 3.3", "valor 3.3", "descripción 3.3" )   
                 
        assert.equal((await instancia.getConstituentParameter(0,0))[0], "clave 1.1", "La clave del primer constituyente no coincide")
        assert.equal((await instancia.getConstituentParameter(1,1))[1], "valor 2.2", "El valor del segundo constituyente no coincide")
        assert.equal((await instancia.getConstituentParameter(2,2))[2], "descripción 3.3", "La descripción del tercer constituyente no coincide")
    });

    it('Crear servicios en los constituyentes e ir actualizando el total de los servicios por constituyente', async() =>{       
        await instancia.setConstituentService(0, "Servicio 0000.0", 0,"https://localhost/servicio001", 3, 3)
        await instancia.setConstituentService(0, "Servicio 0000.1", 0,"https://localhost/servicio002", 3, 3)
        await instancia.setConstituentService(1, "Servicio 0001.0", 0,"https://localhost/servicio003", 3, 3)
        await instancia.setConstituentService(1, "Servicio 0001.1", 0,"https://localhost/servicio004", 3, 3)
        await instancia.setConstituentService(1, "Servicio 0001.2", 0,"https://localhost/servicio005", 3, 3)
        await instancia.setConstituentService(1, "Servicio 0001.3", 0,"https://localhost/servicio003", 3, 3)
        await instancia.setConstituentService(1, "Servicio 0001.4", 0,"https://localhost/servicio003", 3, 3)
        await instancia.setConstituentService(1, "Servicio 0001.5", 0,"https://localhost/servicio003", 3, 3)
        await instancia.setConstituentService(2, "Servicio 0002.0", 0,"https://localhost/servicio003", 3, 3)
        await instancia.setConstituentService(2, "Servicio 0002.1", 0,"https://localhost/servicio003", 3, 3)
        await instancia.setConstituentService(2, "Servicio 0002.2", 0,"https://localhost/servicio003", 3, 3)
    
        for(var i=0;i<await instancia.totalConstituent();i++)
        {
            console.log("Numero de constituyente")            
            console.log(i)             
            for(var j=0;j<await instancia.totalConstituentService(i);j++)
            {
                
                console.log("Numero de servicio")            
                console.log(j)   
                
                let _x = await instancia.getConstituentService(i,j)
                
                console.log(_x[0])
                console.log(_x[1])
                console.log(_x[2])
                console.log(_x[3])
                console.log(_x[4])
                console.log(_x[5])
                
            }
        }

        assert.equal(await instancia.totalConstituentService(0), 2, "Total de servicios del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentService(1), 6, "Total de servicios del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentService(2), 3, "Total de servicios del constituyente no coinciden")
    });
    

    it('Crear parámetros en los servicios de los constituyentes e ir actualizando el total de parámetros por servicio de los constituyente', async() =>{       
        await instancia.setConstituentService(0, "Servicio 0000.0", 0,"https://localhost/servicio001", 3, 3)
        await instancia.setConstituentService(0, "Servicio 0000.1", 0,"https://localhost/servicio002", 3, 3)
        await instancia.setConstituentService(1, "Servicio 0001.0", 0,"https://localhost/servicio003", 3, 3)
        await instancia.setConstituentService(2, "Servicio 0002.0", 0,"https://localhost/servicio003", 3, 3)
        await instancia.setConstituentServiceParameter(0,0,  "clave 0.0.0", "valor 0.0.0", "descripción 0.0.0" );
        await instancia.setConstituentServiceParameter(0,0,  "clave 0.0.1", "valor 0.0.1", "descripción 0.0.1" );
        await instancia.setConstituentServiceParameter(0,0,  "clave 0.0.2", "valor 0.0.2", "descripción 0.0.2" );
        await instancia.setConstituentServiceParameter(0,0,  "clave 0.0.3", "valor 0.0.3", "descripción 0.0.3" );
        await instancia.setConstituentServiceParameter(0,1,  "clave 0.1.0", "valor 0.1.0", "descripción 0.1.0" );
        await instancia.setConstituentServiceParameter(0,1,  "clave 0.1.1", "valor 0.1.1", "descripción 0.1.1" );
        await instancia.setConstituentServiceParameter(0,1,  "clave 0.1.2", "valor 0.1.2", "descripción 0.1.2" );
        await instancia.setConstituentServiceParameter(1,0,  "clave 1.0.0", "valor 1.0.0", "descripción 1.0.0" );
        await instancia.setConstituentServiceParameter(2,0,  "clave 2.0.0", "valor 2.0.0", "descripción 2.0.0" );
        await instancia.setConstituentServiceParameter(2,0,  "clave 2.0.1", "valor 2.0.1", "descripción 2.0.1" );
        
 
    
        for(var i=0;i<await instancia.totalConstituent();i++)
        {
            console.log("Numero de constituyente")            
            console.log(i)             
            for(var j=0;j<await instancia.totalConstituentService(i);j++)
            {
                for(var k=0;k<await instancia.totalConstituentServiceParameter(i,j);k++)
                {
                
                    console.log("Numero de servicio")            
                    console.log(j)   
                    
                    let _x = await instancia.getConstituentServiceParameter(i,j,k)
                    
                    console.log(_x[0])
                    console.log(_x[1])
                    console.log(_x[2])
                }
            }
        }

        assert.equal(await instancia.totalConstituentService(0), 2, "Total de servicios del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentService(1), 1, "Total de servicios del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentService(2), 1, "Total de servicios del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentServiceParameter(0,0), 4, "Total de parámetros del servicio del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentServiceParameter(0,1), 3, "Total de parámetros del servicio del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentServiceParameter(1,0), 1, "Total de parámetros del servicio del constituyente no coinciden")
        assert.equal(await instancia.totalConstituentServiceParameter(2,0), 2, "Total de parámetros del servicio del constituyente no coinciden")
    });

    

/*    
    it('Crear servicios con los datos adecuados en las posiciones adecuadas', async() =>{       
        assert.equal((await instancia.getService(3))[1], "Servicio 0003", "La descripción de la tercera misión no coincide")
    });
    
    it('Crear servicios e ir actualizando el total de los servicios', async() =>{      
        assert.equal(await instancia.totalService(), 3, "Servicios no coinciden con el total de servicios")
    });

    it('Crear parámetros en los servicios e ir actualizando el total de los parámetros por servicio', async() =>{       
        await instancia.setServiceParameter(1, "clave 1.1", "valor 1.1", "descripción 1.1" )
        await instancia.setServiceParameter(1, "clave 1.2", "valor 1.2", "descripción 1.2" )
        await instancia.setServiceParameter(1, "clave 1.3", "valor 1.3", "descripción 1.3" )
        await instancia.setServiceParameter(2, "clave 2.1", "valor 2.1", "descripción 2.1" )
        await instancia.setServiceParameter(2, "clave 2.2", "valor 2.2", "descripción 2.2" )
        await instancia.setServiceParameter(3, "clave 3.1", "valor 3.1", "descripción 3.1" )  

        assert.equal(await instancia.totalServiceParameter(1), 3, "Total de parámetros del servicio no coinciden")
        assert.equal(await instancia.totalServiceParameter(2), 2, "Total de parámetros del servicio no coinciden")
        assert.equal(await instancia.totalServiceParameter(3), 1, "Total de parámetros del servicio no coinciden")
    });

    it('Crear parámetros en los servicios con los datos adecuados en las posiciones adecuadas', async() =>{       
        await instancia.setServiceParameter(1, "clave 1.1", "valor 1.1", "descripción 1.1" )
        await instancia.setServiceParameter(1, "clave 1.2", "valor 1.2", "descripción 1.2" )
        await instancia.setServiceParameter(1, "clave 1.3", "valor 1.3", "descripción 1.3" )
        await instancia.setServiceParameter(2, "clave 2.1", "valor 2.1", "descripción 2.1" )
        await instancia.setServiceParameter(2, "clave 2.2", "valor 2.2", "descripción 2.2" )
        await instancia.setServiceParameter(3, "clave 3.1", "valor 3.1", "descripción 3.1" )  
                 
        assert.equal((await instancia.getServiceParameter(1,0))[0], "clave 1.1", "La clave del primer servicio no coincide")
        assert.equal((await instancia.getServiceParameter(2,1))[1], "valor 2.2", "El valor del segundo servicio no coincide")
        assert.equal((await instancia.getServiceParameter(3,0))[2], "descripción 3.1", "La descripción del tercer servicio no coincide")
    });

*/


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