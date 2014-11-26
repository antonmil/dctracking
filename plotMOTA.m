%%
inifile=fullfile(confdir,'default.ini');
ini=IniConfig();
ini.ReadFile(inifile);

sec='Parameters';
keys = ini.GetKeys(sec);

% param search dimension
ndim=length(keys);
lval=0; uval=2;

resdone=false(1,maxexper);
for r=1:maxexper
    if exist(sprintf('%s/res_%03d.mat',resdir,r),'file')
        resdone(r)=true;
    end
end
resdone=find(resdone);
ndone=numel(resdone);

allmota=-10*ones(1,maxexper);
allmota(resdone)=allmets(resdone,12);

if ndim==1
    u=1:maxexper;
    X=u;
    
    Z=allmota;
    plot(X,Z);
    xlabel('multiplier');
    ylabel('MOTA [%]');
    
    legend('var 1');
    
elseif ndim==2
    gridX=round(sqrt(maxexper));
    gridY=gridX;
    
    % t=1:maxexper;
    % [u,v]=ind2sub([gridX, gridY],t);
    u=1:gridX;
    v=1:gridY;
    X=uval*(u-1)/(gridX-1);
    Y=uval*(v-1)/(gridX-1);
    
    
    Z=reshape(allmota,gridX,gridY);
    surfc(X,Y,Z)
    zlim([-100 100]);
    
    view(2);
    colorbar
    title('MOTA [%]')
    xlabel('multiplier p1');
    ylabel('multiplier p2');
end

set(gca,'FontSize',16);