fprintf('\nClearing:')
closepreview(v_FRONT);
closepreview(v_BOTTOM);
delete(v_BOTTOM); delete(v_FRONT);
clear v_BOTTOM v_FRONT
fprintf('[COMPLETE]\n')