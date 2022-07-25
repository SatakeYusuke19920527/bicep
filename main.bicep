param newVMName string = 'satake003'
param labName string = 'DTL-labo'
param size string = 'Standard_D2s_v3'
param userName string = 'satake'

@secure()
param password string

var labSubnetName = 'DTL-subnet'
var labVirtualNetworkId = resourceId('Microsoft.DevTestLab/labs/virtualnetworks', labName, labVirtualNetworkName)
var labVirtualNetworkName = 'DTL-vnet'
var vmId = resourceId('Microsoft.DevTestLab/labs/virtualmachines', labName, newVMName)
var vmName_var = '${labName}/${newVMName}'

resource vmName 'Microsoft.DevTestLab/labs/virtualmachines@2018-10-15-preview' = {
  name: vmName_var
  location: resourceGroup().location
  properties: {
    labVirtualNetworkId: labVirtualNetworkId
    notes: 'WindowsServer2019-sysprep'
    customImageId: '/subscriptions/8818225c-58f0-44de-a997-92f946312b3b/resourcegroups/dtl/providers/microsoft.devtestlab/labs/dtl-labo/customimages/windowsserver2019-sysprep'
    size: size
    userName: userName
    password: password
    isAuthenticationWithSshKey: false
    labSubnetName: labSubnetName
    disallowPublicIpAddress: false
    storageType: 'Premium'
    allowClaim: false
  }
  dependsOn: [
    runPowerShellInline
  ]
}

resource runPowerShellInline 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'runPowerShellInline'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '6.4'
    primaryScriptUri: 'https://adtllabo9035.blob.core.windows.net/test/test2.ps1'
    supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}
output labVMId string = vmId
