function gs = getgenestruct(str)
%% Get genestruct for sample_pipeline or celltype_pipeline
% Can only be done "manually"

gs.full = [];
switch str
    case 'layer_specific'
        load('fc_data','ls','genes');
        gs.sig = genes(ls.sig);
        gs.cont = genes(ls.cont);
        gs.full = [gs.sig;gs.cont];
    case 'layer23'
        load('fc_data','ls','genes');
        gs.sig = genes(ls.sig&ls.l23);
        gs.cont = genes(ls.cont&ls.l23);
        gs.full = [gs.sig;gs.cont];
    case 'layer4'
        load('fc_data','ls','genes');
        gs.sig = genes(ls.sig&ls.l4);
        gs.cont = genes(ls.cont&ls.l4);
        gs.full = [gs.sig;gs.cont];
    case 'edp23'
        load('fc_data','edp23','genes');
        gs.sig = genes(edp23.sig);
        gs.cont = genes(edp23.cont);
        gs.full = [gs.sig;gs.cont];
    case 'edp4'
        load('fc_data','edp4','genes');
        gs.sig = genes(edp4.sig);
        gs.cont = genes(edp4.cont);
        gs.full = [gs.sig;gs.cont];
    case 'edp_indep'
        load('fc_data','edp23','edp4','genes');
        gs.sig = genes(edp23.sig&edp4.sig);
        gs.cont = genes(edp23.cont&edp4.cont);
        gs.full = [gs.sig;gs.cont];
end