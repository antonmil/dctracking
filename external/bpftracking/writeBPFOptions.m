function status = writeBPFOptions(opt,inifile)
% write ini config file

ini = IniConfig();
ini.AddSections('Parameters');
ini.AddSections('Miscellaneous');

opttmp=opt;

while ~isempty(fieldnames(opttmp))
    fnames=fieldnames(opttmp);
    fieldname=fnames{1};
    ini=parseField(ini,opt,fieldname);
    opttmp=rmfield(opttmp,fieldname);
end

status = ini.WriteFile(inifile);

end

function ini=parseField(ini,opt,fieldname)
    fvalue=getfield(opt,fieldname);
    if isstruct(fvalue)
        opttmp=fvalue;
    else
        sec=getSectionName(fieldname);
        ini.AddKeys(sec,fieldname,fvalue);
    end    
end

function sec=getSectionName(fieldname)
sec='Miscellaneous';
switch(fieldname)

    case {'abclambda', ...
            'BPFalpha', ...
            'pcnums' ...
          }
        sec='Parameters';
end
        

end
